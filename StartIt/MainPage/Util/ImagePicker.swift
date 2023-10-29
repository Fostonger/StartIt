//
//  ImagePicker.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import SwiftUI
import PhotosUI

@MainActor
class ImagePicker: ObservableObject {
    @Published var image: Image?
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let image = try await imageSelection?.loadTransferable(type: Image.self) {
                self.image = image
            }
        } catch {
            print(error.localizedDescription)
            image = nil
        }
    }
}
