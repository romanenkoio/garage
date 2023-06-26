//
//  BasicTableView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//

import UIKit

extension BasicTableView {
    enum TableViewEmptyViewType {
        case large
        case small
    }
    
    class ViewModel: BasicViewModel {
        private(set) var labelVM = BasicLabel.ViewModel()
        private(set) var subLabelVM = BasicLabel.ViewModel()
        private(set) var addButtonVM = BasicButton.ViewModel(style: .primary)
        
        @Published
        private(set) var image: UIImage?
        @Published
        var isEmpty: Bool = true
        @Published
        var emptyViewType: TableViewEmptyViewType? = .large

        func setupEmptyState(
            type: TableViewEmptyViewType? = .large,
            labelVM: BasicLabel.ViewModel,
            sublabelVM: BasicLabel.ViewModel,
            addButtonVM: BasicButton.ViewModel,
            image: UIImage?
        ) {
            self.labelVM = labelVM
            self.addButtonVM = addButtonVM
            self.subLabelVM = sublabelVM
            self.image = image
            self.emptyViewType = type
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
    
    final class SectionViewModel<Cell>: ViewModel {
        typealias Cell = Cell

        @Published
        private(set) var cells = [[Cell]]()
        
        func setCells(_ cells: [[Cell]]) {
            self.cells = cells
            self.isEmpty = cells.isEmpty
        }
    }
}
