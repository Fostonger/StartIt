//
//  MockSearchView.swift
//  StartIt
//
//  Created by Булат Мусин on 15.01.2024.
//

import Foundation

struct MockSearchView {
    static var MockItem: Item {
        Item(id: 1, status: Status(id: 1, description: "On Stock"), name: "Capp",
                        price: 12, description: "Nice Capp for you and your great friends dear customer!!!",
                        location: Location(id: 1, description: "LOMO"),
                        category: Category(id: 1, description: "Just cap"))
    }
}
