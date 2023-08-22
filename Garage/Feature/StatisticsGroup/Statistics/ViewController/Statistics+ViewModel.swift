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
        
        let tableVM = BasicTableView.GenericViewModel<StatisticsType>()
        
        var cells: [StatisticsType] = .empty
        
        init(car: Car) {
            self.car = car
            super.init()
            createCells(car: car)
            
            tableVM.setupEmptyState(
                type: .large,
                labelVM: .init(.text("Недостаточно данных")),
                sublabelVM: .init(.text("Для отображения статистики необходимо добавить хотя бы 2 записи")),
                addButtonVM: .init(),
                image: nil
            )
            
        }
        
        func createCells(car: Car) {
            guard car.records.count >= 2 else { return }

            cells = [
                .averageSumPerYear(car: car),
                .mostFrequentOperation(car: car),
                .mostExpensiveOperation(car: car),
                .mostCheapetsOperation(car: car),
                .mostCheapestOperationPerYear(car: car),
                .mostExpensioveOperationPerYear(car: car)
            ]
                
            tableVM.setCells(cells)

        }
    }
}
