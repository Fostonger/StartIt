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
        body: Encodable?,
        completion: @escaping (Result<T,Error>)->Void
    )
    
    func sendPhoto<T:Decodable>(
        type: T.Type,
        endpoint: Endpoint,
        parameters: [String: Any]?,
        image: Data, seqNum: Int, itemId: Int64,
        completion: @escaping (Result<T,Error>)->Void
    )
    
    func getData(
        endpoint: Endpoint,
        parameters: [String: Any]?,
        completion: @escaping (Result<Data,Error>)->Void
    )
}

class APIClient : APIClientProtocol {
    
    private let baseURL = "http://127.0.0.1:8080/"
    
    func performRequest<T:Decodable>(
        type: T.Type,
        endpoint: Endpoint,
        parameters: [String: Any]? = nil,
        body: Encodable? = nil,
        completion: @escaping (Result<T,Error>)->Void
    )  {
        
        guard var url = URL(string: baseURL + endpoint.getEndpoint()) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
            guard let newUrl = components.url else { return }
            url = newUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        if let body = body {
            do {
                let jsonData = try JSONEncoder().encode(body)
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error serializing JSON: \(error)")
            }
        }
        
        sendData(request: request, completion: completion)
    }
    
    func sendPhoto<T:Decodable>(
        type: T.Type,
        endpoint: Endpoint,
        parameters: [String: Any]? = nil,
        image: Data, seqNum: Int, itemId: Int64,
        completion: @escaping (Result<T,Error>)->Void
    )  {
        
        guard let url = URL(string: baseURL + endpoint.getEndpoint()) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        
        var imageBody = Data()
        let boundary = UUID().uuidString
        imageBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        imageBody.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        imageBody.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        imageBody.append(image)
        imageBody.append("\r\n".data(using: .utf8)!)
        
        // Append seqNum
        imageBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        imageBody.append("Content-Disposition: form-data; name=\"seqNum\"\r\n\r\n".data(using: .utf8)!)
        imageBody.append("\(seqNum)\r\n".data(using: .utf8)!)
        
        // Append itemName
        imageBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        imageBody.append("Content-Disposition: form-data; name=\"item_id\"\r\n\r\n".data(using: .utf8)!)
        imageBody.append("\(itemId)\r\n".data(using: .utf8)!)
        
        imageBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = imageBody
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        sendData(request: request, completion: completion)
    }
    
    func getData(endpoint: Endpoint, parameters: [String : Any]?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard var url = URL(string: baseURL + endpoint.getEndpoint()) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
            guard let newUrl = components.url else { return }
            url = newUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ItemCreationError.photoNotFound))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    private func sendData<T: Decodable>(request: URLRequest, completion: @escaping (Result<T,Error>)->Void) {
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



