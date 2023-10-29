//
//  AddFileInteractor.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class AddItemInteractor: AddItemPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol?
    
    var presenter: AddItemInteractorToPresenter?
    
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> ()) {
        APIClient?.performRequest(
            type: [Category].self,
            endpoint: CategoryEndpoint.categories,
            parameters: nil,
            body: nil
        ) { result in
            switch result {
            case .success(let categories):
                completion(.success(categories))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func fetchLocations(completion: @escaping (Result<[Location], Error>) -> ()) {
        APIClient?.performRequest(
            type: [Location].self,
            endpoint: LocationEndpoint.location,
            parameters: nil,
            body: nil
        ) { result in
            switch result {
            case .success(let locations):
                completion(.success(locations))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func fetchStatuses(completion: @escaping (Result<[Status], Error>) -> ()) {
        APIClient?.performRequest(
            type: [Status].self,
            endpoint: StatusEndpoint.status,
            parameters: nil,
            body: nil
        ) { result in
            switch result {
            case .success(let statuses):
                completion(.success(statuses))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func sendItemData(_ item: Item, completion: @escaping (Result<Item, Error>) -> ()) {
        APIClient?.performRequest(
            type: Item.self,
            endpoint: ItemEndpoint.saveItem,
            parameters: nil,
            body: item, completion: completion
        )
    }
    
    func sendPhoto(_ photoData: Data, seqNum: Int, itemId: Int64, completion: @escaping (Result<Bool, Error>) -> ()) {
        APIClient?.sendPhoto(
            type: Bool.self,
            endpoint: ItemEndpoint.loadImage,
            parameters: nil,
            image: photoData, seqNum: seqNum, itemId: itemId, completion: completion
        )
    }
}
