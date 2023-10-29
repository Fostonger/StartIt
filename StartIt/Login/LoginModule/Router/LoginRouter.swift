//
//  LoginRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation
import SwiftUI

class LoginRouter : LoginPresenterToRouterProtocol {
    private var loginHandler: (User) -> ()
    
    static func createModule(loginHandler: @escaping (User) -> ()) -> LoginView {
        
        var view = LoginView()
        var presenter : any LoginViewToPresenterProtocol & LoginInteractorToPresenter = LoginPresenter()
        var interactor : LoginPresenterToInteractorProtocol = LoginInteractor()
        let router = LoginRouter(loginHandler: loginHandler)
        
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.APIClient = APIClient()
        router.loginHandler = loginHandler
        
        return view
    }
    
    private init(loginHandler: @escaping (User) -> Void) {
        self.loginHandler = loginHandler
    }
    
    func successfulLogin(user: User) {
        loginHandler(user)
    }
    
    
    func getRegistration() -> RegisterView {
        RegisterRouter.createModule(loginHandler: loginHandler)
    }
}
