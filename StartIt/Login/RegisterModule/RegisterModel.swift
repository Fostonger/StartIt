//
//  RegisterModel.swift
//  StartIt
//
//  Created by Булат Мусин on 11.01.2024.
//

import Foundation

struct RegisterModel: Encodable {
    var username: String? = nil
    var password: String? = nil
    var firstName: String? = nil
    var secondName: String? = nil
    var isu: String? = nil
}
