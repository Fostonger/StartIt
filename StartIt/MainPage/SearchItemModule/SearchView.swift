//
//  SearchItemView.swift
//  StartIt
//
//  Created by Булат Мусин on 29.10.2023.
//

import SwiftUI

struct SearchItemView<Model>: View where Model:SearchViewModelInterface & ItemsListViewModelInterface {
    @StateObject var viewModel: Model
    
    var body: some View {
        NavigationView {
            List(viewModel.itemsListModel.items.indices, id: \.self) { index in
                NavigationLink(
                    destination:
                        ItemDetailedView(
                            viewModel: viewModel.itemDetailedViewModel(for: index)
                        )
                ) {
                    ItemViewCell(
                        item: viewModel.itemsListModel.items[index],
                        image: $viewModel.itemsListModel.images[index]
                    )
                }
            }
            .navigationTitle("Items")
            .navigationBarItems(
                leading:
                    SearchBar(text: $viewModel.searchModel.searchString)
                    .frame(width: 250),
                trailing: HStack {
                    Button(action: {
                        viewModel.fetchData()
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    NavigationLink(destination: {
                        VStack {
                            FilterPicker(
                                selectedFilter: $viewModel.searchModel.selectedLocation,
                                filters: viewModel.itemCatalogModel.locations
                            )
                            FilterPicker(
                                selectedFilter: $viewModel.searchModel.selectedCategory,
                                filters: viewModel.itemCatalogModel.categories
                            )
                        }
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            )
        }
        .onAppear {
            viewModel.fetchData()
        }
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

struct FilterPicker<FilterType: Describable>: View {
    @Binding var selectedFilter: FilterType
    let filters: [FilterType]
    
    var body: some View {
        Picker("Filter", selection: $selectedFilter) {
            ForEach(filters) { filter in
                Text(filter.description).tag(filter)
            }
        }
    }
}

//struct SearchItemView_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
