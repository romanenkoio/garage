//
//  StatisticRecords+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 17.09.23.
//  
//

import UIKit

extension MostFrequentOpeartionViewController {
    final class ViewModel: BasicViewModel {
        unowned let car: Car
        let operationType: String
        private(set) var headers: [DateHeaderView.ViewModel] = .empty
        let tableVM = BasicTableView.SectionViewModel<RecordView.ViewModel>()
        
        init(car: Car, operationType: String) {
            self.car = car
            self.operationType = operationType
            super.init()
            
            createTableViewCells()
        }
        
        private func createTableViewCells() {
            let records = car.records.filter({$0.short == operationType})
            let dates = Set(records.compactMap{ $0.date })
            let years = Set(dates.compactMap({ $0.recordComponents.year })).sorted(by: >)

            var cells: [[RecordView.ViewModel]] = .empty
            years.forEach { year in
                let setionCells = records.filter({ $0.date.getDateComponent(.year) == year })
                cells.append(setionCells.map({ .init(record: $0 )}))
            }
            
            headers = years.map({
                DateHeaderView.ViewModel(date: DateComponents(year: $0))
            })
            
            tableVM.setCells(cells)
        }
    }
}
