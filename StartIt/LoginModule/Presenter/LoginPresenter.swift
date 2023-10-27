//
//  LoginPresenter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class LoginPresenter: LoginViewToPresenterProtocol {
    var view: LoginPresenterToViewProtocol?
    var interactor: LoginPresenterToInteractorProtocol?
    var router: LoginPresenterToRouterProtocol?
    
    func login(username: String, password: String) {
        interactor?.login(username: username, password: password)
    }
    
    func getRegistration() -> RegisterView? {
        return router?.getRegistration()
    }
    
}

extension LoginPresenter: LoginInteractorToPresenter {
    func success(user: User) {
        router?.successfulLogin(user: user)
    }
    
    func fail(errorMessage: String) {
        print("erorr \(errorMessage)")
        view?.error(message: errorMessage)
    }
}
