//
//  PastRecords+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.06.23.
//  
//

import UIKit

extension PastRecordsViewController {
    final class ViewModel: BasicControllerModel {
        
        private(set) unowned var car: Car
        
        let tableVM = BasicTableView.GenericViewModel<Record>()
        
        init(car: Car) {
            self.car = car
            super.init()
            readRecords()
            tableVM.setupEmptyState(
                type: .small,
                labelVM: .init(text: "Список записей пуст"),
                sublabelVM: .init(text: "Записей нет"),
                addButtonVM: .init(title: "Добавить запись"),
                image: UIImage(named: "service")
            )
            tableVM.isHiddenButton = true
        }
        
        func readRecords() {
            tableVM.setCells(car.records)
        }
    }
}
