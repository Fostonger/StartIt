//
//  ChatListListProtocol.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

protocol ChatListViewToPresenterProtocol {
    var view: ChatListPresenterToViewProtocol? { get set }
    var interactor: ChatListPresenterToInteractorProtocol? { get set }
    var router: ChatListPresenterToRouterProtocol? { get set }
    
    var imageData: [Data] { get }
    var chats: [Chat] { get }
    
    func getChats()
}

protocol ChatListPresenterToViewProtocol {
    func handleChatsFetch(_ chats: [Chat])
    func handleImageFetch(itemId: Int64, image: Data)
}

protocol ChatListPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol? { get set }
    var presenter: ChatListInteractorToPresenter? { get set }
    
    func fetchChats(user: User, completion: @escaping (Result<[Chat], Error>) -> ())
}

protocol ChatListInteractorToPresenter {
    
}

protocol ChatListPresenterToRouterProtocol {
    static func createModule(with context: AppContext) -> ChatListView
    func getContext() -> AppContext
}
