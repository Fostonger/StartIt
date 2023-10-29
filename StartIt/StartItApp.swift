//
//  StartItApp.swift
//  StartIt
//
//  Created by Булат Мусин on 23.10.2023.
//

import SwiftUI

@main
struct StartItApp: App {
    @State private var user: User? = User(id: 1, name: "Fost", familyName: "Musin", isuNumber: 12, username: "Fost", password: "Fost")
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
