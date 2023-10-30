//
//  ProfileInteractor.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation

class ProfileInteractor: ProfilePresenterToInteractorProtocol {
    
    var APIClient: APIClientProtocol?
    var presenter: ProfileInteractorToPresenter?
    
    func fetchItems(user: User, completion: @escaping (Result<[Item], Error>) -> ()) {
        APIClient?.performRequest(
            type: [Item].self,
            endpoint: ItemEndpoint.fetchItem,
            parameters: SearchFilter(seller: user.id).jsonRepresentation(),
            body: nil, completion: completion)
    }
    
}

