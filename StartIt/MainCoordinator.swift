////
////  HomeView.swift
////  StartIt
////
////  Created by Булат Мусин on 27.10.2023.
////
//
//import SwiftUI
//
//enum MainTab {
//    case home
//    case chats
//    case profile
//}
//
//@MainActor
//class MainCoordinator: ObservableObject {
//
//    // MARK: Stored Properties
//    
//    @Published var tab = MainTab.home
//    
//    @Published var homeCoordinator: HomeCoordinator!
//    @Published var chatsCoordinator: ChatsCoordinator!
//    @Published var profileCoordinator: ProfileCoordinator!
//    
//    init() {
//        homeCoordinator = .init(parent: self)
//        chatsCoordinator = .init(parent: self, willChangeTabTo: .first)
//        profileCoordinator = .init(parent: self)
//    }
//}
//
//struct HomeCoordinatorView: View {
//    
//    // MARK: Stored Properties
//    
//    @ObservedObject var coordinator: HomeCoordinator
//    
//    // MARK: Views
//    
//    var body: some View {
//        TabView(selection: $coordinator.tab) {
//            FirstCoordinatorView(
//                coordinator: coordinator.firstCoordinator
//            )
//            .tabItem { Label("First", systemImage: "doc.text.magnifyingglass") }
//            .tag(MainTab.first)
//            
//            SecondCoordinatorView(
//                coordinator: coordinator.secondCoordinator
//            )
//            .tabItem { Label("Second", systemImage: "star.fill") }
//            .tag(MainTab.second)
//        }
//    }
//}
//
//
//@MainActor
//class HomeViewContext: ObservableObject {
//    @Published var itemCreated: Bool = false {
//        didSet {
//            if itemCreated {
//                selectedTab = 0
//            }
//        }
//    }
//    @Published var selectedTab: Int = 0
//}
//
//struct HomeView: View {
//    @State var context: AppContext
//    @ObservedObject private var homeContext = HomeViewContext()
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        TabView {
//            NavigationView {
//                SearchItemRouter.createModule(with: context)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        NavigationLink(
//                            destination: AddItemRouter.createModule(
//                                context: context, homeContext: homeContext
//                            )
//                        ) {
//                            Image(systemName: "plus")
//                        }
//                        
//                    }
//                }
//            }
//            .tabItem {
//                Image(systemName: "1.square.fill")
//                Text("Home")
//            }
//            .tag(0)
//            
//            ChatListRouter.createModule(with: context)
//            .tabItem {
//                Image(systemName: "2.square.fill")
//                Text("Messages")
//            }
//            .tag(1)
//            
//            ProfileRouter.createModule(with: context)
//            .tabItem {
//                Image(systemName: "3.square.fill")
//                Text("Profile")
//            }
//            .tag(2)
//            
//        }
//        
////        .alert(isPresented: $homeContext.itemCreated, content: {
////            Alert(
////                title: Text("Successfully created"),
////                message: Text("The item was added successfully"),
////                dismissButton: .default(Text("Great!")) {
////                    presentationMode.wrappedValue.dismiss()
////                }
////            )
////        })
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(context: AppContext(user: User(id: 0, name: "", familyName: "", isuNumber: 100, username: "", password: "")))
//    }
//}
