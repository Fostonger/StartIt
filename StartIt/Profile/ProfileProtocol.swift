//
//  ProfileProtocol.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

protocol ProfileViewToPresenterProtocol {
    var view: ProfilePresenterToViewProtocol? { get set }
    var interactor: ProfilePresenterToInteractorProtocol? { get set }
    var router: ProfilePresenterToRouterProtocol? { get set }
    
    var items: [Item] { get }
    
    func getItems()
}

protocol ProfilePresenterToViewProtocol {
    func handleItemsFetch(_ items: [Item])
    func handleImageFetch(itemId: Int64, image: Data)
}

protocol ProfilePresenterToInteractorProtocol {
    var APIClient: APIClientProtocol? { get set }
    var presenter: ProfileInteractorToPresenter? { get set }
    
    func fetchItems(user: User, completion: @escaping (Result<[Item], Error>) -> ())
    
}

protocol ProfileInteractorToPresenter {
    
}

protocol ProfilePresenterToRouterProtocol {
    static func createModule(with context: AppContext) -> ProfileView
    func getContext() -> AppContext
}
