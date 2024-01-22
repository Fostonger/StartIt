//
//  AppState.swift
//  StartIt
//
//  Created by Булат Мусин on 08.01.2024.
//

import Foundation
import Combine

protocol AuthStateService: ObservableObject {
    var userCredentials: Credentials? { get }
    var token: String? { get }
    var expirationDate: Date? { get }
    func setCredentials(_ credentials: Credentials?)
    func setToken(_ token: String, expirationDate: Int32?)
}

protocol AppStateService {
    var searchOptions: ItemCatalogModel { get set }
    var searchOptionsPublisher: Published<ItemCatalogModel>.Publisher { get }
    func fetchSearchOptions()
}

final class MIAppStateService: AppStateService, ObservableObject {
    var searchOptionsPublisher: Published<ItemCatalogModel>.Publisher { $searchOptions }
    @Published var searchOptions: ItemCatalogModel
    private let apiClient: APIClient
    private var cancellables: Set<AnyCancellable> = []
    
    required init(apiClient: APIClient) {
        self.apiClient = apiClient
        _searchOptions = Published(initialValue: ItemCatalogModel())
    }
    
    func fetchSearchOptions() {
        if searchOptions.locations.count < 2 {
            fetchData(endpoint: LocationEndpoint.location, keyPath: \.locations)
        }
        if searchOptions.categories.count < 2 {
            fetchData(endpoint: CategoryEndpoint.categories, keyPath: \.categories)
        }
    }
    
    private func fetchData<T: Decodable>(endpoint: Endpoint, keyPath: WritableKeyPath<ItemCatalogModel, [T]>) {
        apiClient.fetch(with: endpoint, responseType: [T].self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] values in
                self?.searchOptions[keyPath: keyPath].append(contentsOf: values)
            }
            .store(in: &cancellables)
    }
}

final class UserDefaultAppState: AuthStateService {
    @Published private (set) var userCredentials: Credentials?
    private (set) var token: String? {
        get {
            if expirationDate != nil && expirationDate! <= .now {
                _token = nil
            }
            return _token
        }
        set {
            _token = newValue
        }
    }
    private (set) var expirationDate: Date?
    private var _token: String?
    private let credentialsStorage: UserDefaults
    
    init(with credentialsStorage: UserDefaults) {
        self.credentialsStorage = credentialsStorage
        fetchCredentials()
        fetchToken()
    }
    
    private func fetchCredentials() {
        if let data = UserDefaults.standard.object(forKey: UserDefaultKeys.userCredentials.rawValue) as? Data,
           let credentials = try? JSONDecoder().decode(Credentials.self, from: data) {
             userCredentials = credentials
        } else {
            userCredentials = nil
        }
    }
    
    private func fetchToken() {
        token = credentialsStorage.object(forKey: UserDefaultKeys.token.rawValue) as? String
        expirationDate = credentialsStorage.object(forKey: UserDefaultKeys.tokenExpiration.rawValue) as? Date
    }
    
    func setCredentials(_ credentials: Credentials?) {
        if credentials == nil {
            credentialsStorage.removeObject(forKey: UserDefaultKeys.userCredentials.rawValue)
        } else if let encoded = try? JSONEncoder().encode(credentials) {
            credentialsStorage.set(encoded, forKey: UserDefaultKeys.userCredentials.rawValue)
        }
        userCredentials = credentials
    }
    
    func setToken(_ token: String, expirationDate: Int32? = nil) {
        credentialsStorage.setValue(token, forKey: UserDefaultKeys.token.rawValue)
        if let expirationDate = expirationDate {
            credentialsStorage.setValue(Date.now + TimeInterval(expirationDate),
                                        forKey: UserDefaultKeys.tokenExpiration.rawValue)
            self.expirationDate = Date.now + TimeInterval(expirationDate)
        }
        self.token = token
    }
    
    enum UserDefaultKeys: String {
        case tokenExpiration = "token_expiration"
        case userCredentials = "user_credentials"
        case token = "token"
    }
}
