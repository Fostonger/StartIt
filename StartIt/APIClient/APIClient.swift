//
//  APIClient.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Alamofire
import Foundation
import Combine

protocol APIClient: Downloadable, Fetchable { }

final class MIAPIClient<AppService>: APIClient where AppService: AppStateService {
    private let credentialsProvider: AppService
    private let encoder: ParameterEncoder
    private let client: Session
    
    public init(with client: Session, encoder: ParameterEncoder? = nil, credentialsProvider: AppService) {
        self.credentialsProvider = credentialsProvider
        
        let defaultEncoder = JSONParameterEncoder()
        defaultEncoder.encoder.outputFormatting = .prettyPrinted
        self.encoder = encoder != nil ? encoder! : defaultEncoder
        self.client = client
    }
    
    public func fetch<U: Decodable>(with endpoint: Endpoint, responseType: U.Type) -> AnyPublisher<U,APIError> {
        _fetch(with: endpoint, parameters: Optional<Int>.none, responseType: responseType)
    }
    
    public func fetch<T: Encodable, U: Decodable>(with endpoint: Endpoint, parameters: T, responseType: U.Type) -> AnyPublisher<U,APIError> {
        _fetch(with: endpoint, parameters: parameters, responseType: responseType)
    }
    
    private func _fetch<T: Encodable, U: Decodable>(with endpoint: Endpoint, parameters: T? = nil, responseType: U.Type) -> AnyPublisher<U, APIError> {
        guard !endpoint.authRequired || credentialsProvider.token != nil else {
            return withTryAuth {
                self._fetch(with: endpoint, parameters: parameters, responseType: responseType)
            }
        }
        
        var headers = endpoint.headers
        
        if endpoint.authRequired {
            headers.add(.authorization(bearerToken: credentialsProvider.token!))
        }
        
        return client.request(baseUrl + endpoint.getEndpoint(),
                              method: endpoint.method,
                              parameters: parameters,
                              encoder: encoder,
                              headers: headers)
        .validate()
        .publishDecodable(type: U.self)
        .tryMap { response -> U in
            if let data = response.data {
                print(String(data: data, encoding: .utf8)!)
            }
            
            if let afError = response.error {
                throw APIError.network(error: afError)
            } else if response.value == nil {
                throw APIError.dataCorrupted(message: "Received data was corrupted")
            }
            return response.value!
        }
        .catch { error in
            if case .network(let afError) = error as? APIError, afError.responseCode == 401 {
                return self.withTryAuth { [weak self] in
                    guard let self = self else {
                        return Fail(outputType: U.self, failure: APIError.auth(message: ""))
                            .eraseToAnyPublisher()
                    }
                    return self._fetch(with: endpoint, parameters: parameters, responseType: responseType)
                }
                .eraseToAnyPublisher()
            }
            return Fail(error: APIError.dataCorrupted(message: ""))
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    private func withTryAuth<T>(_ handler: @escaping () -> AnyPublisher<T, APIError>) -> AnyPublisher<T, APIError> {
        credentialsProvider.setToken("", expirationDate: -1)
        
        let endpoint = AuthEndpoint.login
        let headers = endpoint.headers
        
        return client.request(baseUrl + endpoint.getEndpoint(),
                              method: endpoint.method,
                              parameters: credentialsProvider.userCredentials,
                              encoder: encoder,
                              headers: headers)
        .validate()
        .publishDecodable(type: AuthResponse.self)
        .flatMap { [weak self] completion -> AnyPublisher<T, APIError> in
            switch completion.result {
            case .success(let response):
                self?.credentialsProvider.setToken(response.token, expirationDate: response.tokenLifetime)
                return handler()
            case .failure(let error):
                return Fail(error: APIError.network(error: error))
                    .eraseToAnyPublisher()
            }
        }
        .handleEvents(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.credentialsProvider.setCredentials(nil)
                print("Authentication failed: \(error)")
            }
        })
        .eraseToAnyPublisher()
    }
    
    private var baseUrl: String {
        "http://147.78.66.203:3210/"
    }
}

extension MIAPIClient: Downloadable {
    func downloadData(from url: URL) -> AnyPublisher<Data?, APIError> {
        client.request(url)
            .validate()
            .publishData()
            .tryMap { response -> Data? in
                guard
                    let httpURLResponse = response.response,
                    httpURLResponse.statusCode == 200
                else {
                    throw APIError.statusCode(message: "Invalid Status Code")
                }
                return response.data
            }
            .mapError { APIError.map($0) }
            .eraseToAnyPublisher()
    }
}
