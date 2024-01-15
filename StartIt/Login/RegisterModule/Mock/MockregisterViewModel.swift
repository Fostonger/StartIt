//
//  MockregisterViewModel.swift
//  StartIt
//
//  Created by Булат Мусин on 15.01.2024.
//

import Foundation
import Mocker

struct MockRegisterViewModel {
    static let registerViewModel: RegisterViewModel = {
        let apiClient = MIAPIClient(with: MockSession.session, credentialsProvider: MockUserDefaultAppState())
        let registerUrl = URL(string: "http://147.78.66.203:3210/" + AuthEndpoint.register.getEndpoint())!

        let mock = Mock(url: registerUrl, dataType: .json, statusCode: 200, data: [
            .post : try! Data(contentsOf: MockedData.successAuthJSON)
        ])
        mock.register()
        let viewModel = RegisterViewModel(apiClient: apiClient)
        return viewModel
    }()
}
