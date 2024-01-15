//
//  MockAppState.swift
//  StartIt
//
//  Created by Булат Мусин on 12.01.2024.
//

import Foundation

final class MockUserDefaultAppState: AppStateService {
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
    
    init(with userCredentials: Credentials? = nil, token: String? = nil, expirationDate: Date? = nil) {
        self.userCredentials = userCredentials
        self.token = token
        self.expirationDate = expirationDate
    }
    
    func setCredentials(_ credentials: Credentials?) {
        userCredentials = credentials
    }
    
    func setToken(_ token: String, expirationDate: Int32? = nil) {
        if let expirationDate = expirationDate {
            self.expirationDate = Date.now + TimeInterval(expirationDate)
        }
        self.token = token
    }
}

