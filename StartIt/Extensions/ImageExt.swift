//
//  ImageExt.swift
//  StartIt
//
//  Created by Булат Мусин on 19.01.2024.
//

import UIKit
import SwiftUI

extension Image {
    init?(from data: Data) {
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
    }
}
