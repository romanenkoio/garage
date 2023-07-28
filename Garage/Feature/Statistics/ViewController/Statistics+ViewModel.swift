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
        let barChartVM = BarChart.GenericViewModel<Record>()

        unowned let car: Car
        var records: [Record]
        @Published var years: [Int] = .empty
        
        init(car: Car) {
            self.car = car
            records = RealmManager().read().filter({ $0.carID == car.id })
         
            self.years = Array(Set(records.compactMap({ $0.date.components.year })).sorted(by: >))
            super.init()
            print(years)
            initBarCharts()
        }
        
        func initBarCharts(year: Int? = nil) {
            var data = records
            var title: TextValue = .text("Расходы за всё время")
            if let year {
                data = records.filter({ $0.date.components.year == year })
                title = .text("Расходы за \(year) год")
            }
            barChartVM.setItems(
                list: data,
                title: title) { items in
                    return items.map({($0.id, $0.date.components.month ?? 0, $0.cost ?? 0)})
                }
        }
    }
}
