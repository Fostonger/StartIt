//
//  UIImage+Resize.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import UIKit

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
