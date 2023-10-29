//
//  HomeView.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import SwiftUI

struct HomeView: View {
    var context: AppContext
    var body: some View {
        TabView {
            NavigationView {
                List {
                    NavigationLink(destination: Text("First Screen")) {
                        Text("Go to First Screen")
                    }
                }
                .navigationTitle("First")
            }
            .tabItem {
                Image(systemName: "1.square.fill")
                Text("Home")
            }

            AddItemRouter.createModule(context: context)
            .tabItem {
                Image(systemName: "2.square.fill")
                Text("Add item")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(context: AppContext(user: User(id: 0, name: "", familyName: "", isuNumber: 100, username: "", password: "")))
    }
}
