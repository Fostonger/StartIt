//
//  LoginViewModel.swift
//  StartIt
//
//  Created by Булат Мусин on 10.01.2024.
//

import Foundation
import Combine

protocol LoginViewModelInterface: ObservableObject {
    var loginModel: LoginModel { get set }
    var presentAlert: Bool { get set }
    var errorMessage: String? { get }
    var loginButtonDisabled: Bool { get set }
    init(apiClient: APIClient)
    func login()
    func createRegisterViewModel() -> RegisterViewModel
}

class LoginViewModel {
    @Published var loginModel: LoginModel
    @Published var presentAlert: Bool = false
    var loginButtonDisabled: Bool = true
    var errorMessage: String? = nil
    private let apiClient: APIClient
    private var cancellables: Set<AnyCancellable> = []

    required init(apiClient: APIClient) {
        self.apiClient = apiClient
        self.loginModel = LoginModel()
        
        $loginModel
            .sink { [weak self] newValue in
                self?.loginButtonDisabled = newValue.email.isEmptyOrNil || newValue.password.isEmptyOrNil
            }
            .store(in: &cancellables)
    }
}

extension LoginViewModel: LoginViewModelInterface {
    func login() {
        apiClient.fetch(with: AuthEndpoint.login, parameters: loginModel, responseType: AuthResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.presentAlert = true
                }
            } receiveValue: { value in
                print(value)
            }
            .store(in: &cancellables)
    }
    
    func createRegisterViewModel() -> RegisterViewModel {
        RegisterViewModel(apiClient: apiClient)
    }
}
