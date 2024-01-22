//
//  ItemDetailedViewModel.swift
//  StartIt
//
//  Created by Булат Мусин on 16.01.2024.
//

import Combine
import Foundation

protocol ItemDetailedViewModelInterface: ObservableObject {
    var itemDetailedModel: ItemDetailedModel { get set }
}

class ItemDetailedViewModel: ItemDetailedViewModelInterface {
    @Published var itemDetailedModel: ItemDetailedModel
    private var cancellable: AnyCancellable?
    
    required init(seqNumber: Int, itemListViewModel: SearchViewModel) {
        _itemDetailedModel = Published(initialValue: ItemDetailedModel(
            item: itemListViewModel.itemsListModel.items[seqNumber],
            image: itemListViewModel.itemsListModel.images[seqNumber]
        ))
        
        itemListViewModel.$itemsListModel
            .map { updatedModel in
                ItemDetailedModel(item: updatedModel.items[seqNumber],
                                  image: updatedModel.images[seqNumber])
            }
            .assign(to: &$itemDetailedModel)
    }
}
