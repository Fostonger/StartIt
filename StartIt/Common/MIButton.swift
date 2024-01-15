//
//  MIButton.swift
//  StartIt
//
//  Created by Булат Мусин on 13.01.2024.
//

import SwiftUI

struct MIButton: View {
    var title: String
    @Binding var disabled: Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(disabled ? Color.gray : Color.blue)
                .cornerRadius(15.0)
        }
        .disabled(disabled)
    }
}
