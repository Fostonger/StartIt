//
//  BindingExt.swift
//  StartIt
//
//  Created by Булат Мусин on 11.01.2024.
//

import Foundation
import SwiftUI

infix operator ?!
extension Binding {
    static func ?!(rhs: Binding<Value?>, lhs: Value) -> Binding<Value> {
        Binding(
            get: { rhs.wrappedValue ?? lhs },
            set: { rhs.wrappedValue = $0 }
        )
    }
}
