//
//  ProfileRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

class ProfileRouter: ProfilePresenterToRouterProtocol {
    private var context: AppContext
    
    static func createModule(with context: AppContext) -> ProfileView {
        var presenter : ProfileViewToPresenterProtocol & ProfileInteractorToPresenter = ProfilePresenter()
        let view = ProfileView(presenter: presenter)
        var interactor : ProfilePresenterToInteractorProtocol = ProfileInteractor()
        let router = ProfileRouter(context: context)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.APIClient = APIClient()
        presenter.getItems()
        
        return view
    }
    
    private init(context: AppContext) {
        self.context = context
    }
    
    func getContext() -> AppContext {
        context
    }
}
