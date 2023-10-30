//
//  ChatVIew.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation
import SwiftUI

@MainActor
class ChatListViewDatabase: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var images: [Image?] = []
}

struct ChatListView: View {
    @ObservedObject var database: ChatListViewDatabase = ChatListViewDatabase()
    var presenter: ChatListViewToPresenterProtocol?
    var body: some View {
        NavigationView {
            VStack {
                if let context = presenter?.router?.getContext() {
                    List(database.chats.indices, id: \.self) { index in
                        NavigationLink(
                            destination: ChatRouter.createModule(
                                with: database.chats[index],
                                context: context)
                        ) {
                            ChatListViewCell(chat: database.chats[index], image: $database.images[index])
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Chats")
    }
}

extension ChatListView: ChatListPresenterToViewProtocol {
    
    func handleChatsFetch(_ chats: [Chat]) {
        DispatchQueue.main.async {
            self.database.chats = chats
            self.database.images = Array(repeating: nil, count: chats.count)
        }
    }
    
    func handleImageFetch(itemId: Int64, image: Data) {
        DispatchQueue.main.async {
            guard let uiImage = UIImage(data: image),
                  let itemIndex = database.chats.firstIndex(where: { $0.item.id == itemId }) else {
                return
            }
            let newImage = uiImage.normalizeByWidth(targetWidth: 100)
            self.database.images[itemIndex] = Image(uiImage: uiImage)
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ChatListView()
        }
    }
}
