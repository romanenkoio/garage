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
        
        let tableVM = BasicTableView.SectionViewModel<RecordView.ViewModel>()
        private(set) var headers: [DateHeaderView.ViewModel] = .empty
        
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
            let records = car.records
            let dates = Set(records.compactMap{ $0.date })
            let years = Set(dates.compactMap({ $0.recordComponents.year })).sorted(by: >)

            var cells: [[RecordView.ViewModel]] = .empty
            years.forEach { year in
                let setionCells = records.filter({ $0.date.recordComponents.year == year })
                cells.append(setionCells.map({ .init(record: $0 )}))
            }
            headers = years.map({ DateHeaderView.ViewModel(date: DateComponents(year: $0))})
            
            tableVM.setCells(cells)
        }
    }
}
