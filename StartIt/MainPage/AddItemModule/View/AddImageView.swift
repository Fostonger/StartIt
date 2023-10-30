//
//  AddImageView.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import SwiftUI
import PhotosUI

struct AddImageView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var imagePicker = ImagePicker()
    
    var presenter: AddItemViewToPresenterProtocol?
    var parentView: AddItemView?
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = imagePicker.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .padding([.bottom, .top], 20)
                    Text("Select a photo of your item")
                        .padding(.bottom, 20)
                }
                
                PhotosPicker(selection: $imagePicker.imageSelection) {
                    Text("Select photo")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    if let image = imagePicker.image {
                        let parameter = 200 / image.size.width
                        let newImage = image.resizeImage(targetSize: CGSize(
                            width: image.size.width * parameter,
                            height: image.size.height * parameter
                        ))
                        presenter?.sendPhoto(
                            newImage.jpegData(compressionQuality: 0)!
                        ) { result in
                            self.parentView?.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Coffee image")
        }
    }
}


struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView()
    }
}
