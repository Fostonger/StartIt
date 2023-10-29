//
//  AddItemProtocols.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

protocol AddItemViewToPresenterProtocol {
    var view: AddItemPresenterToViewProtocol? {get set}
    var interactor: AddItemPresenterToInteractorProtocol? {get set}
    var router: AddItemPresenterToRouterProtocol? {get set}
    
    var categories: [Category] { get }
    var locations:  [Location] { get }
    var statuses:   [Status] { get }
    
    func fetchData()
    func nextStep(item: Item, completion: @escaping (Result<Item, Error>) -> () )
    func sendPhoto(_ photoData: Data, completion: @escaping (Result<Bool, Error>) -> ())
}

protocol AddItemPresenterToViewProtocol {
    func error(message : String)
    func popView()
}

protocol AddItemPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol? { get set }
    var presenter: AddItemInteractorToPresenter? { get set }
    
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> ())
    func fetchLocations(completion: @escaping (Result<[Location], Error>) -> ())
    func fetchStatuses(completion: @escaping (Result<[Status], Error>) -> ())
    func sendItemData(_ item: Item, completion: @escaping (Result<Item, Error>) -> ())
    func sendPhoto(_ photoData: Data, seqNum: Int, itemId: Int64, completion: @escaping (Result<Bool, Error>) -> ())
}

protocol AddItemInteractorToPresenter {
    func success(item: Item)
    func fail(errorMessage: String)
}


protocol AddItemPresenterToRouterProtocol {
    static func createModule(context: AppContext, homeContext: HomeViewContext) -> AddItemView
    func getContext() -> AppContext
    func setContext(_ context: AppContext)
    func successfulItemCreation()
}
