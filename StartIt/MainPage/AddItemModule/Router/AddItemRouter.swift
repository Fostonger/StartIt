//
//  AddItemRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class AddItemRouter: AddItemPresenterToRouterProtocol {
    private let context: AppContext
    
    static func createModule(context: AppContext) -> AddItemView {
        var view = AddItemView()
        var presenter : AddItemViewToPresenterProtocol & AddItemInteractorToPresenter = AddItemPresenter()
        var interactor : AddItemPresenterToInteractorProtocol = AddItemInteractor()
        let router = AddItemRouter(context: context)
        
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.APIClient = APIClient()
        presenter.fetchData()
        
        return view
    }
    
    private init(context: AppContext) {
        self.context = context
    }
    
    func getContext() -> AppContext {
        return context
    }
}
