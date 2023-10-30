//
//  ChatProtocol.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

protocol ChatViewToPresenterProtocol {
    var view: ChatPresenterToViewProtocol? { get set }
    var interactor: ChatPresenterToInteractorProtocol? { get set }
    var router: ChatPresenterToRouterProtocol? { get set }
    
    var messages: [Message] { get }
    var item: Item? { get }
    var imageData: Data { get }
    var chat: Chat { get }
    
    func getMessages()
    func sendMessage(_ message: Message)
}

protocol ChatPresenterToViewProtocol {
    func handleItemFetch(_ item: Item)
    func handleMessagesFetch(_ messages: [Message])
    func handleImageFetch(itemId: Int64, image: Data)
}

protocol ChatPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol? { get set }
    var presenter: ChatInteractorToPresenter? { get set }
    
    func fetchMessages(chat: Chat, completion: @escaping (Result<[Message], Error>) -> ())
    func sendMessage(message: Message, completion: @escaping (Result<Bool, Error>) -> ())
    
}

protocol ChatInteractorToPresenter {
    
}

protocol ChatPresenterToRouterProtocol {
    static func createModule(with chat: Chat, context: AppContext) -> ChatView
    func getContext() -> AppContext
}
