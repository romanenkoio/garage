//
//  Statistics+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.08.23.
//  
//

import UIKit

extension StatisticsViewController {
    final class ViewModel: BasicViewModel {
        unowned let car: Car
        
        let tableVM = BasicTableView.SectionViewModel<StatisticView.ViewModel>()
        private(set) var headers: [DateHeaderView.ViewModel] = .empty
        
        init(car: Car) {
            self.car = car
            super.init()
            
            tableVM.setupEmptyState(
                type: .large,
                labelVM: .init(.text("Недостаточно данных")),
                sublabelVM: .init(.text("Для отображения статистики необходимо добавить хотя бы 2 записи")),
                addButtonVM: .init(),
                image: nil
            )
            createTableCells()
        }
        
        private func createTableCells() {
            let records = car.records
            let dates = Set(records.compactMap{ $0.date })
            let years = Set(dates.compactMap({ $0.recordComponents.year })).sorted(by: >)
            
            var cells: [[StatisticView.ViewModel]] = .empty
            
            cells.insert([
                .init(cellValue: .averageSum(records: records)),
                .init(cellValue: .mostFreqOperation(records: records)),
                .init(cellValue: .mostExpensioveOperation(records: records)),
                .init(cellValue: .mostCheapestOpearation(records: records))
            ], at: 0)
            
            years.forEach { year in
                let sectionCells = records.filter({ $0.date.getDateComponent(.year) == year })
                
                cells.append([
                    .init(cellValue: .averageSum(records: sectionCells)),
                    .init(cellValue: .mostExpensioveOperation(records: sectionCells)),
                    .init(cellValue: .mostCheapestOpearation(records: sectionCells))
                ])
            }
            
            headers = years.map({ DateHeaderView.ViewModel(date: DateComponents(year: $0))})
            headers.insert(.init(textValue: .text("За все время")), at: 0)
            tableVM.setCells(cells)
        }
    }
}
