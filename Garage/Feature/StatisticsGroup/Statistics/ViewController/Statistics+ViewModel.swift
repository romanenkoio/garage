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
                labelVM: .init(.text("Недостаточно данных".localized)),
                sublabelVM: .init(.text("Для отображения статистики необходимо добавить хотя бы 2 записи")),
                addButtonVM: .init(),
                image: nil
            )
            readRecords()
        }
        
        func readRecords() {
            let records = car.records
            let dates = Set(records.compactMap{ $0.date })
            let years = Set(dates.compactMap({ $0.recordComponents.year })).sorted(by: >)
            
            var cells: [[StatisticView.ViewModel]] = .empty
            
            let sum = records.map({$0.cost ?? 0}).reduce(0, +) / 12
            let mostFrequentOperation = Dictionary(
                grouping: records.map({$0.short}),
                by: {$0})
                .max {$0.1.count < $1.1.count}?.key
            let mostExpensiveOperation = records.max(by: {$0.cost ?? 0 < $1.cost ?? 0})
            let mostCheapestOperation = records.max(by: {$0.cost ?? 0 > $1.cost ?? 0})
            let statModel: [StatModel] = [(sum,mostFrequentOperation,mostExpensiveOperation,mostCheapestOperation)]
            
            cells.insert(statModel.map({.init(cellValue: $0)}), at: 0)
            
            years.forEach { year in
                let sectionCells = records.filter({ $0.date.getDateComponent(.year) == year })
                let sum = sectionCells.map({$0.cost ?? 0}).reduce(0, +) / 12
                let mostExpensiveOperationPerYear = sectionCells.max(by: {$0.cost ?? 0 < $1.cost ?? 0})
                let mostCheapestOperationPerYear = sectionCells.max(by: {$0.cost ?? 0 > $1.cost ?? 0})
                let statModel: [StatModel] = [(sum,nil,mostExpensiveOperationPerYear,mostCheapestOperationPerYear)]
                cells.append(statModel.map({.init(cellValue: $0)}))
                print(2)
            }
            
            headers = years.map({ DateHeaderView.ViewModel(date: DateComponents(year: $0))})
            headers.insert(.init(textValue: .text("За все время")), at: 0)
            tableVM.setCells(cells)
        }
    }
}
