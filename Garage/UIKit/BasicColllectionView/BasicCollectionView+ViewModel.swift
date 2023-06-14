//
//  BasicCollectionView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 12.06.23.
//

import UIKit

extension BasicCollectionView {
    class ViewModel: BasicViewModel {
        private(set) var labelVM = BasicLabel.ViewModel()

        @Published
        private(set) var image: UIImage?
        @Published
        var isEmpty: Bool = true

        func setupEmptyState(
            labelVM: BasicLabel.ViewModel,
            image: UIImage?
        ) {
            self.labelVM = labelVM
            self.image = image
        }
    }
    
    final class GenericViewModel<Cell>: ViewModel {
        typealias Cell = Cell

        @Published
        private(set) var cells = [Cell]()
        
        func setCells(_ cells: [Cell]) {
            self.cells = cells
            self.isEmpty = cells.isEmpty
        }
    }
}
