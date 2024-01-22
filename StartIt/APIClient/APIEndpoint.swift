//
//  APIEndpoint.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation
import Alamofire

protocol Endpoint {
    func getEndpoint() -> String
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var authRequired: Bool { get }
    var urlString: String { get }
}

extension Endpoint {
    var urlString: String { "http://147.78.66.203:3210/" + getEndpoint() }
    var method: HTTPMethod      { .get }
    var authRequired: Bool      { true }
    var headers: HTTPHeaders    { [.accept("application/json")] }
}

struct BareUrlEndpoint: Endpoint {
    let urlString: String
    let authRequired: Bool = true
    
    func getEndpoint() -> String { "" }
    var headers: HTTPHeaders    { [.accept(<#T##value: String##String#>)] }
    
}

enum AuthEndpoint: Endpoint {
    case login
    case register
    
    func getEndpoint() -> String {
        switch self {
        case .login:
            return endpointBase + "login"
        case .register:
            return endpointBase + "register"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register:
            return .post
        }
    }
    
    var authRequired: Bool { false }
    
    private var endpointBase: String { "auth/" }
}

enum CategoryEndpoint: Endpoint {
    case categories
    
    func getEndpoint() -> String {
        switch self {
        case .categories:
            return "categories"
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
}

enum StatusEndpoint: Endpoint {
    case status
    
    func getEndpoint() -> String {
        switch self {
        case .status:
            return "statuses"
        }
    }
}

enum ItemEndpoint: Endpoint {
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
    
    var method: HTTPMethod {
        switch self {
        case .saveItem, .loadImage:
            return .post
        case .fetchImage, .fetchItem, .fetchImagePath:
            return .get
        }
    }
    
    private var baseRequest: String { "add_item/" }
}

enum ChatEndpoint: Endpoint {
    case createChat
    case sendMessage
    case getMessages
    case getChats
    
    func getEndpoint() -> String {
        switch self {
        case .createChat:
            return baseRequest + "create_chat"
        case .sendMessage:
            return baseRequest + "send_message"
        case .getMessages:
            return baseRequest + "get_messages"
        case .getChats:
            return baseRequest + "get_chats"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createChat, .sendMessage:
            return .post
        case .getMessages, .getChats:
            return .post
        }
    }
    
    private var baseRequest: String { "chat/" }
}
