//
//  ChatListListRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

class ChatListRouter: ChatListPresenterToRouterProtocol {
    static func createModule(with context: AppContext) -> ChatListView {
        var presenter : ChatListViewToPresenterProtocol & ChatListInteractorToPresenter = ChatListPresenter()
        let view = ChatListView(presenter: presenter)
        var interactor : ChatListPresenterToInteractorProtocol = ChatListInteractor()
        let router = ChatListRouter(context: context)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.APIClient = APIClient()
        presenter.getChats()
        
        return view
    }
    
    private var context: AppContext
    
    private init(context: AppContext) {
        self.context = context
    }
    
    func getContext() -> AppContext {
        context
    }
}

