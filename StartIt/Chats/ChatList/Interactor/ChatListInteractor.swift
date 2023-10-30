//
//  ChatListListInteractor.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

class ChatListInteractor: ChatListPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol?
    var presenter: ChatListInteractorToPresenter?
    
    func fetchChats(user: User, completion: @escaping (Result<[Chat], Error>) -> ()) {
        APIClient?.performRequest(
            type: [Chat].self,
            endpoint: ChatEndpoint.getChats,
            parameters: ["user_id": user.id],
            body: nil, completion: completion)
    }
}
