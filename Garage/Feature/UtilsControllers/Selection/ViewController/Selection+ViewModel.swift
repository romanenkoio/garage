//
//  Selection+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

extension SelectionViewController {
    final class ViewModel: BasicControllerModel {
        let tableVM = BasicTableView.GenericViewModel<Selectable>()

        private var snapshot: [Selectable]

        private var selected: Selectable?
    
        let saveButtonVM = AlignedButton.ViewModel(
            buttonVM: .init(
                title: "Выбрать",
                isEnabled: false,
                style: .primary
            ))
        let searchVM = BasicSearchField.ViewModel(placeholder: "Поиск")
        
        var selectionSuccess: ((Selectable) -> Void)?
        
        init(cells: [Selectable]) {
            self.tableVM.setCells(cells)
            self.snapshot = cells
            super.init()
            
            tableVM.setupEmptyState(
                labelVM: .init(.text("Ваш гараж пуст")),
                sublabelVM: .init(.text("Добавьте машину для \nначала работы")),
                addButtonVM: .init(title: "Добавить документ"),
                image: UIImage(systemName: "car")
            )
            
            saveButtonVM.buttonVM.action = .touchUpInside { [weak self] in
                guard let self,
                      let selected = self.selected
                else { return }
                self.selectionSuccess?(selected)
            }
            
            searchVM.$text.receive(on: DispatchQueue.main).sink { [weak self] searchText in
                guard let self else { return }
                if searchText.isEmpty {
                    self.tableVM.setCells(self.snapshot)
                } else {
                    let cells = cells.filter({
                        $0.title.lowercased().contains(searchText.lowercased())
                    })
                    self.tableVM.setCells(cells)
                }
            }
            .store(in: &cancellables)
        }
        
        func selectCell(at index: IndexPath) {
            self.selected = tableVM.cells[index.row]
            saveButtonVM.buttonVM.isEnabled = true
        }
    }
}
