//
//  APIClient.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

protocol APIClientProtocol {
    func performRequest<T:Decodable>(
        type: T.Type,
        endpoint: Endpoint,
        parameters: [String: Any]?,
        body: [String: Any]?,
        completion: @escaping (Result<T,Error>)->Void
    )
}

class APIClient : APIClientProtocol {
    private let baseURL = "http://127.0.0.1:8080/"
    
    func performRequest<T:Decodable>(
        type: T.Type,
        endpoint: Endpoint,
        parameters: [String: Any]? = nil,
        body: [String: Any]? = nil,
        completion: @escaping (Result<T,Error>)->Void
    )  {
        
        guard let url = URL(string: baseURL + endpoint.getEndpoint()) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        if let body = body {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body)
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error serializing JSON: \(error)")
            }
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                print(String(data: data!, encoding: .utf8))
                let responseData = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(responseData))
            }
            catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}



