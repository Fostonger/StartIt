//
//  SearchItemProtocol.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import Foundation
import UIKit
import SwiftUI

protocol ChatCreatable {
    func createChat(chat: Chat)
    func getUser() -> User?
}
protocol SearchItemViewToPresenterProtocol: AnyObject, ChatCreatable {
    var view: SearchItemPresenterToViewProtocol? {get set}
    var interactor: SearchItemPresenterToInteractorProtocol? {get set}
    var router: SearchItemPresenterToRouterProtocol? {get set}
    
    var items: [Item] { get }
    
    func fetchData(filter: SearchFilter)
}

protocol SearchItemPresenterToViewProtocol {
    func handleItemsFetch(_ items: [Item])
    func handleImageFetch(itemId: Int64, image: Data)
    func handleChatCreation(chat: Chat)
    func popView()
}

protocol SearchItemPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol? { get set }
    var presenter: SearchItemInteractorToPresenter? { get set }
    
    func fetchImage(itemId: Int64, completion: @escaping (Result<Data, Error>) -> ())
    func fetchItems(filter: SearchFilter, completion: @escaping (Result<[Item], Error>) -> ())
    func createChat(chat: Chat, completion: @escaping (Result<Chat, Error>) -> ())
}

protocol SearchItemInteractorToPresenter {
    func success(item: Item)
    func fail(errorMessage: String)
}


protocol SearchItemPresenterToRouterProtocol {
    static func createModule(with context: AppContext) -> SearchItemView
    func getContext() -> AppContext
}
