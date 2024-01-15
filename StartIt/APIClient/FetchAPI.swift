//
//  FetchAPI.swift
//  StartIt
//
//  Created by Булат Мусин on 10.01.2024.
//

import Foundation
import Combine

protocol Fetchable {
    func fetch<T: Encodable, U: Decodable>(with endpoint: Endpoint, parameters: T, responseType: U.Type) -> AnyPublisher<U, APIError>
    func fetch<U: Decodable>(with endpoint: Endpoint, responseType: U.Type) -> AnyPublisher<U, APIError>
}
