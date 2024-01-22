//
//  SearchItemCoordinator.swift
//  StartIt
//
//  Created by Булат Мусин on 15.01.2024.
//

import SwiftUI

@MainActor
final class HomeCoordinator: ObservableObject, Identifiable {
    private unowned let parent: MainCoordinator?
    @Published var viewModel: SearchViewModel!
    @Published var secondCoordinator: SecondCoordinator?
    
    init(parent: MainCoordinator?) {
        self.parent = parent
        self.viewModel = FirstViewModel(coordinator: self)
    }
    
    func openSecond() {
        secondCoordinator = SecondCoordinator(parent: parent, willChangeTabTo: .second)
    }
}

struct FirstCoordinatorView: View {
    
    // MARK: Stored Properties
    
    @ObservedObject var coordinator: FirstCoordinator
    
    // MARK: Views
    
    var body: some View {
        NavigationView {
            FirstView(viewModel: coordinator.viewModel)
                .navigation(item: $coordinator.secondCoordinator) { coordinator in
                    SecondCoordinatorView(coordinator: coordinator)
                }
        }
        .alert(item: $coordinator.alertItem) {
            Alert(title: $0.title, message: $0.message, dismissButton: $0.dismissButton)
        }
    }
}
