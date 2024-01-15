//
//  StringExt.swift
//  StartIt
//
//  Created by Булат Мусин on 13.01.2024.
//

import Foundation

extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        self?.isEmpty ?? true
    }
}
