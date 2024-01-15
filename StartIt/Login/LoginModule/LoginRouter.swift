//
//  LoginRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 10.01.2024.
//

import SwiftUI

enum LoginRouter {
    static func makeRegistrationView(with viewModel: RegisterViewModel) -> some View {
        let view = RegisterView(viewModel: viewModel)
        return view
    }
}
