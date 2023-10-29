//
//  ItemViewCell.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import SwiftUI

struct ItemViewCell: View {
    var item: Item
    @State var image: Image? = nil
    
    var body: some View {
        VStack {
            HStack{
                Text(item.name)
                    .font(.title)
                    .padding()
                Spacer()
                VStack {
                    Text(item.status.description)
                        .font(.subheadline)
                        .padding()
                        .foregroundColor(item.status.id == 1 ? .green : .red)
                    Text(String(format: "%.2f", item.price) + " rub")
                        .font(.subheadline)
                }
            }
            .padding()
            
            if let image = image {
                image
                    .frame(width: 200, height: 200, alignment: .center)
                    .padding()
            } else {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 200, height: 200, alignment: .center)
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
    return ItemViewCell(item: item, image: Image(systemName: "photo"))
}
