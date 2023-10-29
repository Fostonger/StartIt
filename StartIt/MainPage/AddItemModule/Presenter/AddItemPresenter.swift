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
    
    func fetchData() {
        interactor?.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories.sorted(by: { $0.id < $1.id })
            case .failure(let failure):
                self?.view?.error(message: failure.localizedDescription)
            }
        }
        
        interactor?.fetchLocations { [weak self] result in
            switch result {
            case .success(let locations):
                self?.locations = locations.sorted(by: { $0.id < $1.id })
            case .failure(let failure):
                self?.view?.error(message: failure.localizedDescription)
            }
        }
        
        interactor?.fetchStatuses { [weak self] result in
            switch result {
            case .success(let statuses):
                self?.statuses = statuses.sorted(by: { $0.id < $1.id })
            case .failure(let failure):
                self?.view?.error(message: failure.localizedDescription)
            }
        }
    }
    
    func nextStep(item: Item) {
        interactor?.sendItemData(item)
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
