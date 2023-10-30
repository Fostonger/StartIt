//
//  ChatListCellView.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import SwiftUI

struct ChatListViewCell: View {
    var chat: Chat
    @Binding var image: Image?
    
    var body: some View {
        HStack {
            VStack{
                Text(chat.item.name)
                    .font(.headline)
                    .padding()
                Text(chat.customer.name)
                    .font(.headline)
                    .padding()
                
            }
//            
//            Spacer()
            
            if let image = image {
                image
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding()
            } else {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding()
            }
        }.padding()
    }
}

#Preview {
    let item = Item(id: 1, status: Status(id: 1, description: "On Stock"), name: "Capp",
                    price: 12, description: "Nice Capp for you and your great friends dear customer!!!",
                    location: Location(id: 1, description: "LOMO"),
                    category: Category(id: 1, description: "Just cap"),
                    seller: User.defaultUser)
    return ChatListViewCell(chat: Chat(id: 1, item: item, customer: User.defaultUser),
                            image: Binding(
                                get: { Image(systemName: "photo") },
                                set: { _ in }
                            )
    )
}
