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
}
