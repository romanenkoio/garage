//
//  Statistics+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//  
//

import UIKit

extension StatisticsViewController {
    final class ViewModel: BasicViewModel {
        
        let chartsViewVM: ChartsView.ViewModel?
        let tableVM = BasicTableView.SectionViewModel<RecordView.ViewModel>()
        private(set) var headers: [DateHeaderView.ViewModel] = .empty

        unowned let car: Car
        
        init(car: Car) {
            self.car = car
            chartsViewVM = .init(car: car)
            super.init()
            tableVM.isHiddenButton = true
            
            tableVM.setupEmptyState(
                type: .small,
                labelVM: .init(),
                sublabelVM: .init(.text("Выберите период".localized)),
                addButtonVM: .init(),
                image: nil
            )
            
        }
        
        func createRecords(from records: [Record]) {
            let dates = Set(records.compactMap{ $0.date })
            let years = Set(dates.compactMap({ $0.recordComponents.year })).sorted(by: >)

            var cells: [[RecordView.ViewModel]] = .empty
            years.forEach { year in
                let setionCells = records.filter({ $0.date.getDateComponent(.year) == year })
                cells.append(setionCells.map({ .init(record: $0 )}))
            }
            headers = years.map({ DateHeaderView.ViewModel(date: DateComponents(year: $0))})
            
            tableVM.setCells(cells)
        }
    }
}
