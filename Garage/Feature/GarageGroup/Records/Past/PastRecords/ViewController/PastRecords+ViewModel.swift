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
        
        let tableVM = BasicTableView.GenericViewModel<RecordView.ViewModel>()
        
        init(car: Car) {
            self.car = car
            super.init()
            readRecords()
            tableVM.setupEmptyState(
                type: .small,
                labelVM: .init(.text("Записей нет")),
                sublabelVM: .init(.text("Истории обслуживания ещё нет, но вы можете добавить первую запись")),
                addButtonVM: .init(title: "Добавить запись"),
                image: nil
            )
            tableVM.isHiddenButton = true
        }
        
        func readRecords() {
            let vms = car.records.map({ RecordView.ViewModel(record: $0)})
            tableVM.setCells(vms)
        }
    }
}
