//
//  Selection+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

extension SelectionViewController {
    final class ViewModel: BasicViewModel {
        @Published
        private(set) var cells: [UniversalSelectionView.ViewModel]

        private var selected: (any Equatable)?
    
        let saveButtonVM = BasicButton.ViewModel(
            title: "Готово",
            isEnabled: false,
            style: .primary
        )
        let searchVM = BasicSearchField.ViewModel( placeholder: "Начните искать тут...")
        
        var selectionSuccess: ((any Equatable) -> Void)?
        
        init(cells: [UniversalSelectionView.ViewModel]) {
            self.cells = cells
            super.init()
            
            saveButtonVM.action = .touchUpInside { [weak self] in
                guard let self,
                      let selected = self.selected
                else { return }
                self.selectionSuccess?(selected)
            }
        }
        
        func selectCell(at index: IndexPath) {
            self.selected = cells[index.row].item
            saveButtonVM.isEnabled = true
        }
    }
}
