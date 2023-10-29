//
//  SearchItemInteractor.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import Foundation

class SearchItemInteractor: SearchItemPresenterToInteractorProtocol {
    
    var APIClient: APIClientProtocol?
    
    var presenter: SearchItemInteractorToPresenter?
    
    func fetchImage(itemId: Int64, completion: @escaping (Result<Data, Error>) -> ()) {
        APIClient?.getData(
            endpoint: ItemEndpoint.fetchImagePath,
            parameters: ["item_id" : "\(itemId)"])
        { [weak self] result in
            switch result {
            case .success(let pathData):
                guard let path = String(data: pathData, encoding: .utf8) else {
                    completion(.failure(ItemCreationError.photoNotFound))
                    return
                }
                self?.APIClient?.getData(
                    endpoint: ItemEndpoint.fetchImage,
                    parameters: ["image_path": path],
                    completion: completion
                )
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func fetchItems(filter: SearchFilter, completion: @escaping (Result<[Item], Error>) -> ()) {
        APIClient?.performRequest(
            type: [Item].self,
            endpoint: ItemEndpoint.fetchItem,
            parameters: filter.jsonRepresentation(),
            body: nil, completion: completion)
    }
}
