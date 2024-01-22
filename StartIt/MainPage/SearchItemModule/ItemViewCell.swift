//
//  ItemViewCell.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import SwiftUI

struct ItemViewCell: View {
    var item: Item
    @Binding var image: Image?
    
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

//#Preview {
//    return ItemViewCell(item: MockSearchView.MockItem, image: Image(systemName: "photo"))
//}
