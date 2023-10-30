//
//  ChatPresenter.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

class ChatPresenter: ChatViewToPresenterProtocol {
    var chat: Chat
    var item: Item? = nil
    var imageData: Data = Data()
    var messages: [Message] = []
    
    init(chat: Chat) {
        self.chat = chat
        self.item = chat.item
    }
    
    var view: ChatPresenterToViewProtocol?
    var interactor: ChatPresenterToInteractorProtocol?
    var router: ChatPresenterToRouterProtocol?
    
    func getMessages() {
        guard let user = router?.getContext().user else {
            return
        }
        interactor?.fetchMessages(chat: chat) { [weak self] result in
            switch result {
            case .success(let messages):
                self?.messages = messages
                self?.view?.handleMessagesFetch(messages)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    
    func sendMessage(_ message: Message) {
        interactor?.sendMessage(message: message) { [weak self] result in
            switch result {
            case .success(_):
                self?.getMessages()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}

extension ChatPresenter: ChatInteractorToPresenter {
    
}
