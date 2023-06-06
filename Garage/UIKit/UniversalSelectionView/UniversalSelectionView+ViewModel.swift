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
        let item: any Equatable
        let title: String
        
        init(
            labelVM: BasicLabel.ViewModel,
            item: any Equatable,
            title: String
        ) {
            self.labelVM = labelVM
            self.item = item
            self.title = title
        }
    }
}
