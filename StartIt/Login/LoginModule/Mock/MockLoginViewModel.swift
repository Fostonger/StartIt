//
//  MockLoginViewModel.swift
//  StartIt
//
//  Created by Булат Мусин on 12.01.2024.
//

import Foundation
import Mocker

struct MockLoginViewModel {
    static let loginViewModel: LoginViewModel = {
        let apiClient = MIAPIClient(with: MockSession.session, credentialsProvider: MockUserDefaultAppState())
        let loginUrl = URL(string: "http://147.78.66.203:3210/" + AuthEndpoint.login.getEndpoint())!

        let mock = Mock(url: loginUrl, dataType: .json, statusCode: 200, data: [
            .post : try! Data(contentsOf: MockedData.successAuthJSON)
        ])
        mock.register()
        let viewModel = LoginViewModel(apiClient: apiClient)
        return viewModel
    }()
}
