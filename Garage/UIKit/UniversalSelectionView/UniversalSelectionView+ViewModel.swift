//
//  UniversalSelectionView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

extension UniversalSelectionView {
    final class ViewModel: BasicViewModel {
        let labelVM: BasicLabel.ViewModel
        let item: Selectable
        
        init(
            labelVM: BasicLabel.ViewModel,
            item: Selectable,
            title: String
        ) {
            self.labelVM = labelVM
            self.item = item
        }
        
        init(_ item: Selectable) {
            self.labelVM = .init(.text(item.title))
            self.item = item
        }
    }
}
