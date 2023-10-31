//
//  Structs.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

struct User: Codable, Hashable {
    static let defaultUser = User(id: 1, name: "Fost", familyName: "Musin", isuNumber: 12, username: "Fost", password: "Fost")
    
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

protocol Describable {
    var id: Int64 { get }
    var description: String { get }
}

struct Status: Codable, Hashable, Describable {
    let id: Int64
    let description: String
}

struct Location: Codable, Hashable, Describable {
    let id: Int64
    let description: String
}

struct Category: Codable, Hashable, Describable {
    let id: Int64
    let description: String
}

struct Photo: Codable {
    let id: Int64
    let itemId: Item
    let seqNumber: Int64
    let photoPath: String
    
    private enum CodingKeys : String, CodingKey {
        case id
        case itemId = "item_id", seqNumber = "seq_number", photoPath = "photo_path"
    }
}

struct Item: Codable, Hashable {
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

struct SearchFilter: Codable, Hashable {
    var itemName: String? = nil
    var category: Int64? = nil
    var location: Int64? = nil
    var seller:   Int64? = nil
    
    private enum CodingKeys : String, CodingKey {
        case itemName = "item_name"
        case category, seller, location
    }
    
    func jsonRepresentation() -> [String: Any] {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return [ : ]
            }
            
            return dictionary
        } catch {
            return [ : ]
        }
    }
}

struct Chat: Codable {
    let id: Int64
    let item: Item
    let customer: User
}

struct Message: Codable, Identifiable {
    let id: Int64
    let chat: Chat
    let message: String
    let seqNumber: Int
    let sender: User
}
