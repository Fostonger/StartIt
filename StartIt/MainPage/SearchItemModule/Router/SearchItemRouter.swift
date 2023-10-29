//
//  SearchItemRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import Foundation
import SwiftUI

class SearchItemRouter: SearchItemPresenterToRouterProtocol {
    private var context: AppContext
    
    static func createModule(with context: AppContext) -> SearchItemView {
        let presenter : SearchItemViewToPresenterProtocol & SearchItemInteractorToPresenter = SearchItemPresenter()
        let view = SearchItemView(presenter: presenter)
        var interactor : SearchItemPresenterToInteractorProtocol = SearchItemInteractor()
        let router = SearchItemRouter(context: context)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.APIClient = APIClient()
        presenter.fetchData(filter: SearchFilter())
        
        return view
    }
    
    private init(context: AppContext) {
        self.context = context
    }
    
    func getContext() -> AppContext {
        context
    }
}
