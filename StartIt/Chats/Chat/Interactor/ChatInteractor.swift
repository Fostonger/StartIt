//
//  ChatInteractor.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

class ChatInteractor: ChatPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol?
    var presenter: ChatInteractorToPresenter?
    
    func fetchMessages(chat: Chat, completion: @escaping (Result<[Message], Error>) -> ()) {
        APIClient?.performRequest(
            type: [Message].self,
            endpoint: ChatEndpoint.getMessages,
            parameters: ["chat_id": chat.id],
            body: nil, completion: completion)
    }
    
    func sendMessage(message: Message, completion: @escaping (Result<Message, Error>) -> ()) {
        APIClient?.performRequest(
            type: Message.self,
            endpoint: ChatEndpoint.sendMessage,
            parameters: nil,
            body: message) { [weak self] result in
                switch result {
                case .success(let success):
                    self?.fetchMessages(chat: success.chat) { result in
                        switch result {
                        case .success(let success):
                            self?.presenter?.handleMessages(success)
                        case .failure(let failure):
                            print(failure.localizedDescription)
                        }
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
                completion(result)
            }
    }
}
