//
//  SceneDelegate.swift
//  StartIt
//
//  Created by Булат Мусин on 08.01.2024.
//

import UIKit
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let appState = UserDefaultAppState(with: UserDefaults.standard)
        let apiClient = MIAPIClient(with: AF, credentialsProvider: appState)
        
        window = UIWindow(windowScene: scene)
        window?.backgroundColor = .red
        
//        let loginHandler: (Credentials) -> () = { [unowned self] _ in
//            self.window?.rootViewController = CoffeeshopsListRouter.createModule(apiClient: apiClient,
//                                                                            credService: appState)
//        }
//        
//        if let credentials = appState.userCredentials {
//            loginHandler(credentials)
//        } else {
//            window?.rootViewController = LoginRouter.createModule(loginHandler: loginHandler,
//                                                                  apiClient: apiClient,
//                                                                  credService: appState)
//        }
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
    }
}
