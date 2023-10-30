//
//  ProfileView.swift
//  StartIt
//
//  Created by Булат Мусин on 30.10.2023.
//

import SwiftUI

struct ProfileView: View {
    var presenter: ProfileViewToPresenterProtocol?
    
    @ObservedObject var database: DetailedViewDatabase = DetailedViewDatabase()
    
    var user: User {
        presenter?.router?.getContext().user ?? User.defaultUser
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Name:")
                        .font(.headline)
                    Spacer()
                    Text(user.name)
                    Text(user.familyName)
                }
                .padding()
                HStack {
                    Text("ISU number:")
                        .font(.headline)
                    Spacer()
                    Text("\(user.isuNumber)")
                }
                .padding()
                Text("Items in store:")
                List(database.items.indices, id: \.self) { index in
                    NavigationLink(destination: ItemDetailedView(database: database, index: index)) {
                        ItemViewCell(item: database.items[index], image: database.images[index])
                    }
                }
            }
        }
    }
}

extension ProfileView: ProfilePresenterToViewProtocol {
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
            let parameter = 200 / uiImage.size.width
            let newImage = uiImage.resizeImage(targetSize: CGSize(
                width: uiImage.size.width * parameter,
                height: uiImage.size.height * parameter
            ))
            database.images[itemIndex] = Image(uiImage: newImage)
        }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

