//
//  AddItemView.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//
import SwiftUI

struct AddItemView: View {
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var selectedCategory: Category?
    @State private var selectedLocation: Location?
    @State private var description: String = ""
    @State private var alertIsPresented = false
    @State private var alertMessage = ""
    
    var presenter: AddItemViewToPresenterProtocol?
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Name", text: $itemName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                TextField("Price", text: $itemPrice)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                TextField("Description", text: $description)
                    .lineLimit(nil)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                if let categories = presenter?.categories {
                    Picker("Select category", selection: $selectedCategory) {
                        ForEach(categories, id: \.id) { category in
                            Text(category.description).tag(category as Category?)
                        }
                    }
                }
                
                if let locations = presenter?.locations {
                    Picker("Select location", selection: $selectedLocation) {
                        ForEach(locations, id: \.id) { location in
                            Text(location.description).tag(location as Location?)
                        }
                    }
                }
                
                Button(action: {
                    guard let location = selectedLocation,
                          let category = selectedCategory,
                          let status = presenter?.statuses.first(where: { $0.id == 1}),
                          let user = presenter?.router?.getContext().user
                    else {
                        return
                    }
                    let item = Item(
                        id: 0, status: status,
                        name: itemName, price: Double(itemPrice) ?? 0,
                        description: description, location: location,
                        category: category, seller: user
                    )
                    presenter?.nextStep(item: item)
                    NavigationLink(destination: <#T##() -> View#>, label: <#T##() -> View#>)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .alert(isPresented: $alertIsPresented, content: {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                })
                
                Spacer()
            }
            .padding()
        }
    }
}

extension AddItemView: AddItemPresenterToViewProtocol {
    func error(message: String) {
        alertMessage = message
        alertIsPresented = true
    }
}


struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
