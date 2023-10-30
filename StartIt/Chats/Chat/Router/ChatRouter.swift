//
//  ChatRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

class ChatRouter: ChatPresenterToRouterProtocol {
    private var context: AppContext
    
    static func createModule(with chat: Chat, context: AppContext) -> ChatView {
        var presenter : ChatViewToPresenterProtocol & ChatInteractorToPresenter = ChatPresenter(chat: chat)
        let view = ChatView(presenter: presenter)
        var interactor : ChatPresenterToInteractorProtocol = ChatInteractor()
        let router = ChatRouter(context: context)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.APIClient = APIClient()
        presenter.getMessages()
        
        return view
    }
    
    private init(context: AppContext) {
        self.context = context
    }
    
    func getContext() -> AppContext {
        context
    }
}
