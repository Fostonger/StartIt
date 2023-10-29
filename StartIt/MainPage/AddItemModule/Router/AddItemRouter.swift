//
//  AddItemRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class AddItemRouter: AddItemPresenterToRouterProtocol {
    private var context: AppContext
    private var homeContext: HomeViewContext?
    
    static func createModule(context: AppContext, homeContext: HomeViewContext) -> AddItemView {
        var view = AddItemView(homeContext: homeContext)
        var presenter : AddItemViewToPresenterProtocol & AddItemInteractorToPresenter = AddItemPresenter()
        var interactor : AddItemPresenterToInteractorProtocol = AddItemInteractor()
        let router = AddItemRouter(context: context, homeContext: homeContext)
        
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.APIClient = APIClient()
        presenter.fetchData()
        
        return view
    }
    
    private init(context: AppContext, homeContext: HomeViewContext) {
        self.context = context
        self.homeContext = homeContext
    }
    
    func successfulItemCreation() {
        DispatchQueue.main.async {
            self.homeContext?.itemCreated = true
        }
    }
    
    func getContext() -> AppContext {
        return context
    }
    
    func setContext(_ context: AppContext) {
        self.context = context
    }
}
