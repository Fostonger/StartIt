//
//  ChatListListPresenter.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

class ChatListPresenter: ChatListViewToPresenterProtocol {
    var imageData: [Data] = []
    var chats: [Chat] = []
    
    
    var view: ChatListPresenterToViewProtocol?
    var interactor: ChatListPresenterToInteractorProtocol?
    var router: ChatListPresenterToRouterProtocol?
    
    func getChats() {
        guard let user = router?.getContext().user else {
            return
        }
        interactor?.fetchChats(user: user) { [weak self] result in
            switch result {
            case .success(let chats):
                self?.view?.handleChatsFetch(chats)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}

extension ChatListPresenter: ChatListInteractorToPresenter {
    
}
