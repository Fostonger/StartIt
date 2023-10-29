//
//  Structs.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

struct User: Codable {
    let id: Int64
    let name: String
    let familyName: String
    let isuNumber: Int
    let username: String
    let password: String
    
    private enum CodingKeys : String, CodingKey {
        case id, name, username, password
        case familyName = "family_name", isuNumber = "isu_number"
    }
}

struct Status: Codable {
    let id: Int64
    let description: String
}

struct Location: Codable, Hashable {
    let id: Int64
    let description: String
}

struct Category: Codable, Hashable {
    let id: Int64
    let description: String
}

struct Item: Codable {
    let id: Int64
    let status: Status
    let name: String
    let price: Double
    let description: String
    let location: Location
    let category: Category
    let seller: User
    
    private enum CodingKeys : String, CodingKey {
        case id, name, price, description, status, location, seller, category
    }
}
