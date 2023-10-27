//
//  APIEndpoint.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

protocol Endpoint {
    func getEndpoint() -> String
    var method: String { get }
}

enum LoginEndpoint: Endpoint {
    case login
    case register
    
    func getEndpoint() -> String {
        switch self {
        case .login:
            return "login"
        case .register:
            return "register"
        }
    }
    
    var method: String {
        switch self {
        case .login:
            return "POST"
        case .register:
            return "POST"
        }
    }
}
