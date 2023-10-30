//
//  SearchItemView.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import SwiftUI

@MainActor
class DetailedViewDatabase: ObservableObject {
    @Published var images: [Image?] = []
    @Published var items: [Item] = []
}

class SearchItemViewDatabase: DetailedViewDatabase {
    @Published var locations: [Location] = []
    @Published var categories: [Category]
    var chatToPresent: Chat? = nil
    @Published var shouldPresentChat: Bool = false
    
    init(presenter: SearchItemViewToPresenterProtocol?) {
        var categories = presenter?.router?.getContext().categories ?? []
        categories.insert(Category(id: -1, description: "Not selected"), at: 0)
        self.categories = categories
        super.init()
        
        var locations = presenter?.router?.getContext().locations ?? []
        locations.insert(Location(id: -1, description: "Not selected"), at: 0)
        self.locations = locations
    }
    
    func update(with context: AppContext?) {
        var categories = context?.categories ?? []
        categories.insert(Category(id: -1, description: "Not selected"), at: 0)
        self.categories = categories
        
        var locations = context?.locations ?? []
        locations.insert(Location(id: -1, description: "Not selected"), at: 0)
        self.locations = locations
    }
}

struct SearchItemView: View {
    
    init(presenter: SearchItemViewToPresenterProtocol?) {
        self.presenter = presenter
        self.database = SearchItemViewDatabase(presenter: presenter)
    }
    
    var presenter: SearchItemViewToPresenterProtocol?
    @ObservedObject var database: SearchItemViewDatabase
    @State var searchText: String = ""
    @State var selectedCategoryId: Int64 = -1
    @State var selectedLocationId: Int64 = -1
    
    var body: some View {
        NavigationView {
            List(database.items.indices, id: \.self) { index in
                NavigationLink(destination: ItemDetailedView(database: database, chatCreator: presenter, index: index)) {
                    ItemViewCell(item: database.items[index], image: database.images[index])
                }
            }
            .navigationTitle("Items")
            .navigationBarItems(
                leading: SearchBar(text: $searchText).frame(width: 250),
                trailing: HStack {
                    Button(action: {
                        let selectedFilters = SearchFilter(
                            itemName: searchText.isEmpty ? nil : searchText,
                            category: selectedCategoryId == -1 ? nil : selectedCategoryId,
                            location: selectedLocationId == -1 ? nil : selectedLocationId
                        )
                        presenter?.fetchData(filter: selectedFilters)
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    NavigationLink(destination: {
                        VStack {
                            FilterPicker(selectedFilters: $selectedLocationId, filters: database.locations)
                            FilterPicker(selectedFilters: $selectedCategoryId, filters: database.categories)
                        }.onAppear {
                            if (database.categories.count == 1) {
                                database.update(with: presenter?.router?.getContext())
                            }
                        }
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                    if let chatToPresent = database.chatToPresent,
                        let context = presenter?.router?.getContext() {
                        NavigationLink(
                            destination: ChatRouter.createModule(
                                with: chatToPresent,
                                context: context),
                            isActive: $database.shouldPresentChat
                        ) {
                            EmptyView()
                        }
                    }
                }
            )
        }
    }
}

extension SearchItemView: SearchItemPresenterToViewProtocol {
    func handleChatCreation(chat: Chat) {
        DispatchQueue.main.async {
            self.database.chatToPresent = chat
            self.database.shouldPresentChat = true
        }
    }
    
    func handleItemsFetch(_ items: [Item]) {
        DispatchQueue.main.async {
            self.database.items = items
            self.database.images = Array(repeating: nil, count: items.count)
        }
    }
    
    func handleImageFetch(itemId: Int64, image: Data) {
        DispatchQueue.main.async {
            guard let itemIndex = database.items.firstIndex(where: { $0.id == itemId }),
                  let uiImage = UIImage(data: image) else {
                return
            }
            let newImage = uiImage.normalizeByWidth(targetWidth: 200)
            database.images[itemIndex] = Image(uiImage: newImage)
        }
    }
    
    func popView() {
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .opacity(text.isEmpty ? 0 : 1)
            }
        }
        .padding(.horizontal)
    }
}

struct FilterPicker: View {
    @Binding var selectedFilters: Int64
    let filters: [Describable]
    
    var body: some View {
        Picker("Filter", selection: $selectedFilters) {
            ForEach(0..<filters.count) {
                Text(self.filters[$0].description).tag(self.filters[$0].id)
            }
        }
    }
}

struct SearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        let items = [
            Item(id: 1, status: Status(id: 1, description: "On Stock"), name: "Capp",
                            price: 12, description: "Nice Capp for you and your great friends dear customer!!!",
                            location: Location(id: 1, description: "LOMO"),
                            category: Category(id: 1, description: "Just cap"),
                            seller: User(id: 1, name: "Seller", familyName: "Sellth", isuNumber: 311,
                                         username: "bestseller", password: "123456")),
            Item(id: 2, status: Status(id: 2, description: "Out"), name: "Lesson",
                            price: 0, description: "Nice Capp for you and your great friends dear customer!!!",
                            location: Location(id: 1, description: "LOMO"),
                            category: Category(id: 1, description: "Just cap"),
                            seller: User(id: 1, name: "Seller", familyName: "Sellth", isuNumber: 311,
                                         username: "bestseller", password: "123456")),
            Item(id: 1, status: Status(id: 1, description: "On Stock"), name: "Capp",
                            price: 12, description: "Nice Capp for you and your great friends dear customer!!!",
                            location: Location(id: 1, description: "LOMO"),
                            category: Category(id: 1, description: "Just cap"),
                            seller: User(id: 1, name: "Seller", familyName: "Sellth", isuNumber: 311,
                                         username: "bestseller", password: "123456"))
        ]
        SearchItemView(presenter: nil)
    }
}
