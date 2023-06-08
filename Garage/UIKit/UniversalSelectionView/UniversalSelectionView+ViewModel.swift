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
        
        init(_ model: Model) {
            self.labelVM = .init(text: model.modelName)
            self.item = model
            self.title = model.modelName
        }
        
        init(_ brand: Brand) {
            self.labelVM = .init(text: brand.name)
            self.item = brand
            self.title = brand.name
        }
    }
}
