//
//  HomeView.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import SwiftUI

@MainActor
class HomeViewContext: ObservableObject {
    @Published var itemCreated: Bool = false {
        didSet {
            if itemCreated {
                selectedTab = 0
            }
        }
    }
    @Published var selectedTab: Int = 0
}

struct HomeView: View {
    var context: AppContext
    @ObservedObject private var homeContext = HomeViewContext()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        TabView {
            NavigationView {
                List {
                    NavigationLink(destination: Text("First Screen")) {
                        Text("Go to First Screen")
                    }
                }
                .navigationTitle("First")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(
                            "Add item",
                            destination: AddItemRouter.createModule(
                                context: context, homeContext: homeContext
                            )
                        )
                        
                    }
                }
            }
            .tabItem {
                Image(systemName: "1.square.fill")
                Text("Home")
            }
            .tag(0)
            
            AddItemRouter.createModule(context: context, homeContext: homeContext)
            .tabItem {
                Image(systemName: "2.square.fill")
                Text("Add item")
            }
            .tag(1)
        }
        
//        .alert(isPresented: $homeContext.itemCreated, content: {
//            Alert(
//                title: Text("Successfully created"),
//                message: Text("The item was added successfully"),
//                dismissButton: .default(Text("Great!")) {
//                    presentationMode.wrappedValue.dismiss()
//                }
//            )
//        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(context: AppContext(user: User(id: 0, name: "", familyName: "", isuNumber: 100, username: "", password: "")))
    }
}
