//
//  RegisterPresenter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class RegisterPresenter: RegisterViewToPresenterProtocol {
    var view: RegisterPresenterToViewProtocol?
    var interactor: RegisterPresenterToInteractorProtocol?
    var router: RegisterPresenterToRouterProtocol?
    
    func register(user: User) {
        interactor?.register(user: user)
    }
}

extension RegisterPresenter: RegisterInteractorToPresenter {
    func success(user: User) {
        router?.successfulRegistration(user: user)
    }
    
    func fail(errorMessage: String) {
        print("erorr \(errorMessage)")
        view?.error(message: errorMessage)
    }
}
