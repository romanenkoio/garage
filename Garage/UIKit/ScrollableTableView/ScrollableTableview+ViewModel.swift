//
//  ScrollableTableview+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 23.06.23.
//

import UIKit

extension ScrollableTableView {
    class ViewModel: BasicViewModel {

    }
    
    final class GenericViewModel<Cell>: ViewModel {
        typealias Cell = Cell

        @Published
        private(set) var cells = [Cell]()
        
        func setCells(_ cells: [Cell]) {
            self.cells = cells
        }
    }
    
    final class SectionViewModel<Cell>: ViewModel {
        typealias Cell = Cell

        @Published
        private(set) var cells = [[Cell]]()
        
        func setCells(_ cells: [[Cell]]) {
            self.cells = cells
        }
    }
}
