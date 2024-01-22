//
//  SearchModel.swift
//  StartIt
//
//  Created by Булат Мусин on 15.01.2024.
//

import SwiftUI

struct ItemCatalogModel {
    var locations:  [Location]  = [Location(id: -1, description: "Not selected")]
    var categories: [Category]  = [Category(id: -1, description: "Not selected")]
}

struct SearchModel: Encodable {
    var selectedLocation: Location
    var selectedCategory: Category
    var searchString: String = ""
    
    var searchFilter: SearchFilter {
        SearchFilter(
            itemName: searchString.isEmpty ? nil : searchString,
            category: selectedCategory.id == -1 ? nil : selectedCategory.id,
            location: selectedLocation.id == -1 ? nil : selectedLocation.id
        )
    }
    
    enum CodingKeys: CodingKey {
        case selectedLocation
        case selectedCategory
        case searchString
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.selectedLocation, forKey: .selectedLocation)
        try container.encodeIfPresent(self.selectedCategory, forKey: .selectedCategory)
        try container.encodeIfPresent(self.searchString, forKey: .searchString)
    }
}

protocol Describable: Hashable, Identifiable {
    var id: Int64 { get }
    var description: String { get }
}

struct Status: Codable, Describable {
    let id: Int64
    let description: String
}

struct Location: Codable, Describable {
    var id: Int64
    let description: String
}

struct Category: Codable, Describable {
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
//    let seller: User
    
    private enum CodingKeys : String, CodingKey {
        case id, name, price, description, status, location, category//, seller
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
