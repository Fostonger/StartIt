//
//  StartItApp.swift
//  StartIt
//
//  Created by Булат Мусин on 23.10.2023.
//

import SwiftUI

@main
struct StartItApp: App {
    @State private var user: User? = nil
    var body: some Scene {
        WindowGroup {
            if user == nil {
                LoginRouter.createModule { user in
                    self.user = user
                }
            } else {
                HomeView(context: AppContext(user: user!))
            }
        
        }
    }
}
