//
//  AuthModel.swift
//  StartIt
//
//  Created by Булат Мусин on 08.01.2024.
//

import Foundation

struct AuthResponse: Decodable {
    let token: String
    let tokenLifetime: Int32?
}

struct Credentials: Codable {
    let password: String
    let login: String
}
