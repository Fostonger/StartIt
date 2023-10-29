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

enum CategoryEndpoint: Endpoint {
    case categories
    
    func getEndpoint() -> String {
        switch self {
        case .categories:
            return "categories"
        }
    }
    
    var method: String {
        switch self {
        case .categories:
            return "GET"
        }
    }
}

enum LocationEndpoint: Endpoint {
    case location
    
    func getEndpoint() -> String {
        switch self {
        case .location:
            return "locations"
        }
    }
    
    var method: String {
        switch self {
        case .location:
            return "GET"
        }
    }
}

enum StatusEndpoint: Endpoint {
    case status
    
    func getEndpoint() -> String {
        switch self {
        case .status:
            return "statuses"
        }
    }
    
    var method: String {
        switch self {
        case .status:
            return "GET"
        }
    }
}

enum ItemEndpoint: Endpoint {
    var baseRequest: String {
        "add_item/"
    }
    case saveItem
    case loadImage
    case fetchImagePath
    case fetchImage
    case fetchItem
    
    func getEndpoint() -> String {
        switch self {
        case .saveItem:
            return baseRequest + "create_item"
        case .loadImage:
            return baseRequest + "upload_photo"
        case .fetchImage:
            return baseRequest + "fetch_image"
        case .fetchItem:
            return baseRequest + "fetch_item"
        case .fetchImagePath:
            return baseRequest + "fetch_image_path"
        }
    }
    
    var method: String {
        switch self {
        case .saveItem, .loadImage:
            return "POST"
        case .fetchImage, .fetchItem, .fetchImagePath:
            return "GET"
        }
    }
}
