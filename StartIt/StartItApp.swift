//
//  StartItApp.swift
//  StartIt
//
//  Created by Булат Мусин on 23.10.2023.
//

import SwiftUI
import Alamofire

@main
struct StartItApp: App {
    @StateObject private var appStateService = UserDefaultAppState(with: UserDefaults.standard)
    
    var body: some Scene {
        let apiClient = MIAPIClient(with: AF, credentialsProvider: appStateService)
        WindowGroup {
            if appStateService.userCredentials == nil {
                let viewModel = MockLoginViewModel.loginViewModel
//                let viewModel = LoginViewModel(apiClient: apiClient)
                LoginView(viewModel: viewModel)
            } //else {
//                HomeView(context: AppContext(user: user!))
//            }
        
        }
    }
}
