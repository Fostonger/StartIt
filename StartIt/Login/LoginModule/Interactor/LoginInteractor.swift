//
//  LoginInteractor.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class LoginInteractor : LoginPresenterToInteractorProtocol {
    var APIClient: APIClientProtocol?
    var presenter: LoginInteractorToPresenter?
    
    func login(username: String, password: String) {
        let params = [
            "username": username,
            "password": password
        ]
        APIClient?.performRequest(
            type: User.self,
            endpoint: LoginEndpoint.login,
            parameters: nil,
            body: params) { result in
            switch result {
            case .success(let user):
                self.presenter?.success(user: user)
            case .failure(let error):
                self.presenter?.fail(errorMessage: error.localizedDescription)
            }
        }
    }
}
