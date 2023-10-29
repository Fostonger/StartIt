//
//  RegisterRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class RegisterRouter: RegisterPresenterToRouterProtocol {
    var loginHandler: (User) -> ()
    
    static func createModule(loginHandler: @escaping (User) -> ()) -> RegisterView {
        
        var view = RegisterView()
        var presenter : RegisterViewToPresenterProtocol & RegisterInteractorToPresenter = RegisterPresenter()
        var interactor : RegisterPresenterToInteractorProtocol = RegisterInteractor()
        let router = RegisterRouter(loginHandler: loginHandler)
        
        
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
    
    func successfulRegistration(user: User) {
        loginHandler(user)
    }
}
