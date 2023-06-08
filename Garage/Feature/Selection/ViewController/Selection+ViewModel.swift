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
        private(set) var cells: [Selectable]
        private var snapshot: [Selectable]

        private var selected: Selectable?
    
        let saveButtonVM = BasicButton.ViewModel(
            title: "Готово",
            isEnabled: false,
            style: .primary
        )
        let searchVM = BasicSearchField.ViewModel( placeholder: "Начните искать тут...")
        
        var selectionSuccess: ((Selectable) -> Void)?
        
        init(cells: [Selectable]) {
            self.cells = cells
            self.snapshot = cells
            super.init()
            
            saveButtonVM.action = .touchUpInside { [weak self] in
                guard let self,
                      let selected = self.selected
                else { return }
                self.selectionSuccess?(selected)
            }
            
            searchVM.$text.receive(on: DispatchQueue.main).sink { [weak self] searchText in
                guard let self else { return }
                if searchText.isEmpty {
                    self.cells = self.snapshot
                } else {
                    self.cells = cells.filter({
                        $0.title.lowercased().contains(searchText.lowercased())
                    })
                }
               
            }
            .store(in: &cancellables)
        }
        
        func selectCell(at index: IndexPath) {
            self.selected = cells[index.row]
            saveButtonVM.isEnabled = true
        }
    }
}
