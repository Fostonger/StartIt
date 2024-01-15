//
//  registerViewModel.swift
//  StartIt
//
//  Created by Булат Мусин on 11.01.2024.
//

import Foundation
import Combine

protocol RegisterViewModelInterface: ObservableObject {
    var registerModel: RegisterModel { get set }
    var presentAlert: Bool { get set }
    var errorMessage: String? { get }
    var registerButtonDisabled: Bool { get set }
    init(apiClient: APIClient)
    func register()
}

class RegisterViewModel {
    @Published var registerModel: RegisterModel
    @Published var presentAlert: Bool = false
    var errorMessage: String? = nil
    private let apiClient: APIClient
    var registerButtonDisabled: Bool = true
    private var cancellables = Set<AnyCancellable>()

    required init(apiClient: APIClient) {
        self.apiClient = apiClient
        self.registerModel = RegisterModel()
        
        $registerModel
            .sink { [weak self] newValue in
                self?.registerButtonDisabled = newValue.firstName.isEmptyOrNil || newValue.secondName.isEmptyOrNil || newValue.password.isEmptyOrNil || newValue.isu.isEmptyOrNil || newValue.username.isEmptyOrNil
            }
            .store(in: &cancellables)
    }
}

extension RegisterViewModel: RegisterViewModelInterface {
    func register() {
        apiClient.fetch(with: AuthEndpoint.register, parameters: registerModel, responseType: AuthResponse.self)
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
}
