//
//  Downloadable.swift
//  StartIt
//
//  Created by Булат Мусин on 10.01.2024.
//

import Foundation
import Combine

protocol Downloadable {
    func downloadData(with endpoint: Endpoint) -> AnyPublisher<Data, APIError>
    func downloadData<T: Encodable>(with endpoint: Endpoint, parameters: T) -> AnyPublisher<Data, APIError>
}
