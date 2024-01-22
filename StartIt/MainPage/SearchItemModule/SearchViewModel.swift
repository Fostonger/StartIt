//
//  SearchViewModel.swift
//  StartIt
//
//  Created by Булат Мусин on 15.01.2024.
//

import Foundation
import Combine
import SwiftUI

protocol SearchViewModelInterface: ObservableObject {
    var searchModel: SearchModel { get set }
    func fetchData()
    func fetchSearchOptions()
}

protocol ItemsListViewModelInterface: ObservableObject {
    var itemsListModel: ItemsListModel { get set }
    var itemCatalogModel: ItemCatalogModel { get set }
    var presentAlert: Bool { get set }
    var errorMessage: String? { get }
    func createItemViewModel() -> RegisterViewModel
    func itemDetailedViewModel(for index: Int) -> ItemDetailedViewModel
}

class SearchViewModel {
    @Published var searchModel: SearchModel
    @Published var itemsListModel: ItemsListModel
    @Published var itemCatalogModel: ItemCatalogModel
    @Published var presentAlert: Bool = false
    var errorMessage: String? = nil
    private let apiClient: APIClient
    private let appState: AppStateService
    private var cancellables: Set<AnyCancellable> = []
    
    required init<T: AppStateService>(apiClient: APIClient, appState: T) {
        self.apiClient = apiClient
        self.appState = appState
        
        itemCatalogModel = appState.searchOptions
        searchModel = SearchModel(selectedLocation: appState.searchOptions.locations[0],
                                  selectedCategory: appState.searchOptions.categories[0])
        itemsListModel = ItemsListModel(images: [], items: [])
        
        appState.searchOptionsPublisher
            .assign(to: &$itemCatalogModel)
    }
}

extension SearchViewModel: ItemsListViewModelInterface {
    func createItemViewModel() -> RegisterViewModel {
        RegisterViewModel(apiClient: apiClient)
    }
    
    func itemDetailedViewModel(for index: Int) -> ItemDetailedViewModel {
        ItemDetailedViewModel(seqNumber: index, itemListViewModel: self)
    }
    
    func createRegisterViewModel() -> RegisterViewModel {
        RegisterViewModel(apiClient: apiClient)
    }
}

extension SearchViewModel: SearchViewModelInterface {
    func fetchData() {
        apiClient.fetch(with: ItemEndpoint.fetchItem, parameters: searchModel, responseType: [Item].self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.presentAlert = true
                }
            } receiveValue: { [weak self] items in
                guard let self = self else { return }
                self.itemsListModel = ItemsListModel(images: self.itemsListModel.images, items: items)
                self.fetchImagePath()
            }
            .store(in: &cancellables)
    }

    func fetchSearchOptions() {
        appState.fetchSearchOptions()
    }

    private func fetchImagePath() {
        itemsListModel.items.enumerated().forEach { (index, item) in
            apiClient.downloadData(with: ItemEndpoint.fetchImagePath, parameters: ["item_id": item.id])
                .tryMap { data -> String in
                    guard let string = String(data: data, encoding: .utf8) else {
                        throw APIError.dataCorrupted(message: "Couldn't parse image path url from response")
                    }
                    return string
                }
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.presentAlert = true
                    }
                } receiveValue: { [weak self] data in
                    guard let self = self else { return }
                    self.fetchImage(for: index, with: BareUrlEndpoint(urlString: data))
                }
                .store(in: &cancellables)
        }
    }
    
    private func fetchImage(for index: Int, with endpoint: Endpoint) {
        apiClient.downloadData(with: ItemEndpoint.fetchImage, parameters: ["image_path": endpoint.urlString])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.presentAlert = true
                }
            } receiveValue: { [weak self] imageData in
                self?.itemsListModel.images[index] = Image(from: imageData)
            }
            .store(in: &cancellables)
    }
}
