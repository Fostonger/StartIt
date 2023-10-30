//
//  ItemDetailedView.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import SwiftUI

struct ItemDetailedView: View {
    @ObservedObject var database: DetailedViewDatabase
    var chatCreator: ChatCreatable?
    let index: Int
    var body: some View {
        VStack {
            Text(database.items[index].name)
                    .font(.largeTitle)
                    .padding()
            if let image = database.images[index] {
                image
                    .frame(width: 300, height: 100, alignment: .center)
                    .padding()
            } else {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
            
            Divider()
                .padding()
            
            Text(database.items[index].description)
            
            Divider()
                .padding()
            HStack {
                Text("\(database.items[index].seller.name) \(database.items[index].seller.familyName)")
                    .padding()
            }
            
            Divider()
                .padding()
            Text(String(format: "%.2f", database.items[index].price))
                .padding()
            
            HStack {
                Button(action: {
                    if let chatCreator = chatCreator, let user = chatCreator.getUser() {
                        chatCreator.createChat(chat:
                                                Chat(id: 0,
                                                     item: database.items[index],
                                                     customer: user))
                    }
                }) {
                    Text("Open chat")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                NavigationLink(destination: {
                    ProfileRouter.createModule(with: AppContext(user: database.items[index].seller))
                }) {
                    Text("Seller's profile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
            }
            
            Spacer()
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
    let db = SearchItemViewDatabase(presenter: nil)
    db.items = [item];
    db.images = [nil]
    return ItemDetailedView(database: db, index: 0)
}
