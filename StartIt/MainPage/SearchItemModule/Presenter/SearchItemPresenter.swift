//
//  SearchItemPresenter.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import Foundation

class SearchItemPresenter: SearchItemViewToPresenterProtocol {
    
    var view: SearchItemPresenterToViewProtocol?
    
    var interactor: SearchItemPresenterToInteractorProtocol?
    
    var router: SearchItemPresenterToRouterProtocol?
    
    var categories: [Category] = []
    var locations:  [Location] = []
    var statuses:   [Status] = []
    var items: [Item] = []
    
    func fetchData(filter: SearchFilter) {
        interactor?.fetchItems(filter: filter) { [weak self] result in
            switch result {
            case .success(let items):
                self?.items = items
                self?.view?.handleItemsFetch(items)
                items.forEach { item in
                    self?.interactor?.fetchImage(itemId: item.id) { result in
                        switch result {
                        case .success(let imageData):
                            self?.view?.handleImageFetch(itemId: item.id, image: imageData)
                        case .failure(let failure):
                            self?.fail(errorMessage: failure.localizedDescription)
                        }
                    }
                }
            case .failure(let failure):
                self?.fail(errorMessage: failure.localizedDescription)
            }
        }
    }
}

// TODO: handle successful addition
extension SearchItemPresenter: SearchItemInteractorToPresenter {
    func createChat(chat: Chat) {
        interactor?.createChat(chat: chat) { [weak self] result in
            switch result {
            case .success(let success):
                self?.view?.handleChatCreation(chat: success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getUser() -> User? {
        return router?.getContext().user
    }
    
    func success(item: Item) {
        print(item)
    }
    
    func fail(errorMessage: String) {
        print("erorr \(errorMessage)")
    }
}
