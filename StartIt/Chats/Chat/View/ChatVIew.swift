//
//  ChatVIew.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import Foundation
import SwiftUI

@MainActor
class ChatViewDatabase: ObservableObject {
    @Published var messages: [Message] = []
    @Published var item: Item? = nil
    @Published var image: Image? = nil
    
    var lastMessageNumber: Int {
        messages.min(by: { $0.seqNumber > $1.seqNumber })?.seqNumber ?? 0
    }
}

struct ChatView: View {
    @ObservedObject var database = ChatViewDatabase()
    
    var presenter: ChatViewToPresenterProtocol?
    
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack {
            if let item = presenter?.item {
                ItemPreviewView(item: item, image: $database.image)
            }
            ScrollViewReader { proxy in
                List(database.messages) { message in
                    MessageRow(message: message,
                               userSent: message.sender.id == presenter?.router?.getContext().user.id ?? 0)
                }
                .onAppear(perform: {
                    scrollToBottom(proxy)
                })
            }
            
            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Send") {
                    sendMessage()
                }
                .padding(.trailing)
            }
        }
        .navigationBarTitle("Chat")
    }
    
    func sendMessage() {
        guard !newMessage.isEmpty,
              let chat = presenter?.chat,
              let user = presenter?.router?.getContext().user else { return }
        
        let message = Message(id: 0, chat: chat, message: newMessage,
                              seqNumber: database.lastMessageNumber + 1 as! Int, sender: user)
        presenter?.sendMessage(message)
        
        newMessage = ""
    }
    
    func scrollToBottom(_ proxy: ScrollViewProxy) {
        if let lastMessage = database.messages.last {
            DispatchQueue.main.async {
                withAnimation {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }
}

extension ChatView: ChatPresenterToViewProtocol {
    func handleItemFetch(_ item: Item) {
        DispatchQueue.main.async {
            self.database.item = item
        }
    }
    
    func handleMessagesFetch(_ messages: [Message]) {
        DispatchQueue.main.async {
            self.database.messages = messages
        }
    }
    
    func handleImageFetch(itemId: Int64, image: Data) {
        DispatchQueue.main.async {
            guard let uiImage = UIImage(data: image) else { return }
            let newImage = uiImage.normalizeByWidth(targetWidth: 100)
            self.database.image = Image(uiImage: newImage)
        }
    }
}



struct MessageRow: View {
    var message: Message
    let userSent: Bool
    
    var body: some View {
        HStack {
            if userSent {
                Spacer()
            }
            
            Text(message.message)
                .padding(10)
                .background(userSent ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            
            if !userSent {
                Spacer()
            }
        }
        .padding(.vertical, 5)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatRouter.createModule(
                with: Chat(id: 0,
                           item: Item(id: 1, status: Status(id: 1, description: "On Stock"), name: "Capp",
                                      price: 12, description: "Nice Capp for you and your great friends dear customer!!!",
                                      location: Location(id: 1, description: "LOMO"),
                                      category: Category(id: 1, description: "Just cap"),
                                      seller: User.defaultUser), customer: User.defaultUser),
                context: AppContext(user: User.defaultUser))
        }
    }
}
