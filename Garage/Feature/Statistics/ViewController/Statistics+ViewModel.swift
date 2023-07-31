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
        let pieChartVM = PieChart.GenericViewModel<Record>()
        let flipviewVM = FlipView.ViewModel()

        unowned let car: Car
        var records: [Record]
        @Published var years: [Int] = .empty
        @Published var categories: [String] = .empty
        
        init(car: Car) {
            self.car = car
            records = RealmManager().read().filter({ $0.carID == car.id })
         
            self.years = Array(Set(records.compactMap({ $0.date.components.year })).sorted(by: >))
            super.init()

            // MARK: Init BarCharts
            initBarCharts()
            initPieCharts()
            initBarSuggestions()
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
        
        func initPieCharts(year: Int? = nil) {
            var data = records
            var title: TextValue = .text("Категории за всё время")
            if let year {
                data = records.filter({$0.date.components.year == year})
                title = .text("Категории за \(year) год")
            }
            
            pieChartVM.setItems(
                list: data,
                title: title) { items in
                    return items.map({($0.cost ?? 0, $0.short)})
                }
        }

                
        func initBarSuggestions() {
            var suggestions: [SuggestionView.ViewModel] = .empty
            let vm = SuggestionView.ViewModel(labelVM: .init(.text("Весь период")))
            vm.labelVM.action = { [weak self] in
                self?.barChartVM.changeSelection(vm)
                self?.pieChartVM.changeSelection(vm)
                self?.initBarCharts()
                self?.initPieCharts()
                self?.barChartVM.changePeriodSubject.send()
                self?.pieChartVM.changePeriodSubject.send()
            }
            suggestions.append(vm)
            vm.isSelected = true
            
            years.forEach { [weak self] year in
                let vm = SuggestionView.ViewModel(labelVM: .init(.text(year.toString())))
                vm.labelVM.action = { [weak self] in
                    self?.barChartVM.changeSelection(vm)
                    self?.pieChartVM.changeSelection(vm)
                    self?.initBarCharts(year: year)
                    self?.initPieCharts(year: year)
                    self?.barChartVM.changePeriodSubject.send()
                    self?.pieChartVM.changePeriodSubject.send()
                }
                suggestions.append(vm)
            }
            barChartVM.suggestions = suggestions
            pieChartVM.suggestions = suggestions
        }
    }
}
