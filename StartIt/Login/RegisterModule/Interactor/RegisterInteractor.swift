//
//  RegisterInteractor.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class RegisterInteractor: RegisterPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol?
    
    var presenter: RegisterInteractorToPresenter?
    
    func register(user: User) {
        APIClient?.performRequest(
            type: User.self,
            endpoint: LoginEndpoint.register,
            parameters: nil,
            body: user
        ) { [weak self] result in
            switch result {
            case .success(let user):
                self?.presenter?.success(user: user)
            case .failure(let error):
                self?.presenter?.fail(errorMessage: error.localizedDescription)
            }
        }
    }
    
    
}
