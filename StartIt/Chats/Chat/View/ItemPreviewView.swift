//
//  ItemPreviewView.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import SwiftUI

struct ItemPreviewView: View {
    var item: Item
    @Binding var image: Image?
    
    var body: some View {
        HStack {
            VStack{
                Text(item.name)
                    .font(.title)
                    .padding()
                Text(String(format: "%.2f", item.price) + " rub")
                    .font(.subheadline)
            }
            .padding()
            
            Spacer()
            
            if let image = image {
                image
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding()
            } else {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding()
            }
        }
    }
}

#Preview {
    let item = Item(id: 1, status: Status(id: 1, description: "On Stock"), name: "Capp",
                    price: 12, description: "Nice Capp for you and your great friends dear customer!!!",
                    location: Location(id: 1, description: "LOMO"),
                    category: Category(id: 1, description: "Just cap"),
                    seller: User(id: 1, name: "Seller", familyName: "Sellth", isuNumber: 311,
                                 username: "bestseller", password: "123456"))
    return ItemPreviewView(item: item, image: Binding(get: {Image(systemName: "photo")}, set: {_ in}))
}
