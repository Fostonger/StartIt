//
//  ProfilePresenter.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

class ProfilePresenter: ProfileViewToPresenterProtocol {
    var items: [Item] = []
    
    var view: ProfilePresenterToViewProtocol?
    var interactor: ProfilePresenterToInteractorProtocol?
    var router: ProfilePresenterToRouterProtocol?
    
    func getItems() {
        guard let user = router?.getContext().user else {
            return
        }
        interactor?.fetchItems(user: user) { [weak self] result in
            switch result {
            case .success(let items):
                self?.items = items
                self?.view?.handleItemsFetch(items)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}

// TODO: handle successful addition
extension ProfilePresenter: ProfileInteractorToPresenter {
    
}
