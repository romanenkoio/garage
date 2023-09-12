//
//  FAQ+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 11.09.23.
//  
//

import UIKit

extension FAQViewController {
    final class ViewModel: BasicViewModel {
        let tableVM = BasicTableView.SectionViewModel<FAQDisplayable>()
        let cells: [[FAQDisplayable]] = [Liquid.allCases, Filters.allCases, Electro.allCases, Mechanic.allCases]

        override init() {
            super.init()
            tableVM.setCells(cells)
        }

    }
}
