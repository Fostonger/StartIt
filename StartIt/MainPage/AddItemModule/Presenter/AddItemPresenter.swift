//
//  AddItemPresenter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class AddItemPresenter: AddItemViewToPresenterProtocol {
    
    var view: AddItemPresenterToViewProtocol?
    
    var interactor: AddItemPresenterToInteractorProtocol?
    
    var router: AddItemPresenterToRouterProtocol?
    
    var categories: [Category] = []
    var locations:  [Location] = []
    var statuses:   [Status] = []
    private var item: Item?
    
    func fetchData() {
        interactor?.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories.sorted(by: { $0.id < $1.id })
                if var context = self?.router?.getContext(),
                    let sortedCategories = self?.categories {
                    context.categories = sortedCategories
                    self?.router?.setContext(context)
                }
            case .failure(let failure):
                self?.view?.error(message: failure.localizedDescription)
            }
        }
        
        interactor?.fetchLocations { [weak self] result in
            switch result {
            case .success(let locations):
                self?.locations = locations.sorted(by: { $0.id < $1.id })
                if var context = self?.router?.getContext(),
                    let sortedLocations = self?.locations {
                    context.locations = sortedLocations
                    self?.router?.setContext(context)
                }
            case .failure(let failure):
                self?.view?.error(message: failure.localizedDescription)
            }
        }
        
        interactor?.fetchStatuses { [weak self] result in
            switch result {
            case .success(let statuses):
                self?.statuses = statuses.sorted(by: { $0.id < $1.id })
                if var context = self?.router?.getContext(),
                    let sortedStatuses = self?.statuses {
                    context.statuses = sortedStatuses
                    self?.router?.setContext(context)
                }
            case .failure(let failure):
                self?.view?.error(message: failure.localizedDescription)
            }
        }
    }
    
    func nextStep(item: Item, completion: @escaping (Result<Item, Error>) -> () ) {
        self.item = item
        completion(.success(item))
    }
    
    func sendPhoto(_ photo: Data, completion: @escaping (Result<Bool, Error>) -> () ) {
        guard var item = self.item else {
            completion(.failure(ItemCreationError.photoNotFound))
            return
        }
        interactor?.sendItemData(item) { [weak self] result in
            switch result {
            case .success(let success):
                self?.item = success
                item = success
                self?.success(item: success)
            case .failure(let failure):
                self?.fail(errorMessage: failure.localizedDescription)
            }
            self?.interactor?.sendPhoto(photo, seqNum: 1, itemId: item.id) { result in
                switch result {
                case .success(_):
                    self?.router?.successfulItemCreation()
                    self?.view?.popView()
    //                self?.success(item: success)
                case .failure(let failure):
                    self?.fail(errorMessage: failure.localizedDescription)
                }
                completion(result)
            }
        }
    }
}

// TODO: handle successful addition
extension AddItemPresenter: AddItemInteractorToPresenter {
    func success(item: Item) {
        print(item)
    }
    
    func fail(errorMessage: String) {
        print("erorr \(errorMessage)")
        view?.error(message: errorMessage)
    }
}
