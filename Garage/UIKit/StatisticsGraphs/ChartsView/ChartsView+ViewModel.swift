//
//  FlipView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 30.07.23.
//

import UIKit
import Combine

extension ChartsView {
    class ViewModel: BasicViewModel {
        let barChartVM = BarChart.GenericViewModel<Record>()
        let pieChartVM = PieChart.GenericViewModel<Record>()
        var barChartSuggestion: SuggestionView.ViewModel?
        var pieChartSuggestion: SuggestionView.ViewModel?

    
        var changePeriodSubject: PassthroughSubject<Void, Never> = .init()
        @Published var pageIndex = 0
        unowned let car: Car
        
        init(car: Car) {
            self.car = car
            super.init()
            initBarCharts()
            initPieCharts()
        }
        
        func initBarCharts(with year: Int? = nil) {
            var data = car.records
            if let year {
                barChartVM.year = year
                data = car.records.filter({ $0.date.components.year == year })
            } else {
                barChartVM.year = nil
            }

            barChartVM.setItems(
                list: data) { items in
                    return items.map({($0.id, $0.date.components.month ?? 0, $0.cost ?? 0)})
                }
        }

        func initPieCharts(with year: Int? = nil) {
            var data = car.records
            if let year {
                pieChartVM.year = year
                data = car.records.filter({$0.date.components.year == year})
            } else {
                pieChartVM.year = nil
            }

            pieChartVM.setItems(
                list: data) { items in
                    return items.map({($0.cost ?? 0, $0.short)})
                }
        }
//
//
//        func initBarSuggestions() {
//            var suggestions: [SuggestionView.ViewModel] = .empty
//            let vm = SuggestionView.ViewModel(labelVM: .init(.text("Весь период")))
//            vm.labelVM.action = { [weak self] in
//                self?.changeSelection(vm)
//                switch self?.pageIndex {
//                    case 0: self?.initBarCharts()
//                    case 1: self?.initPieCharts()
//                    default: break
//                }
//                self?.changePeriodSubject.send()
//            }
//            suggestions.append(vm)
//            vm.isSelected = true
//
//            years.forEach { [weak self] year in
//                let vm = SuggestionView.ViewModel(labelVM: .init(.text(year.toString())))
//                vm.labelVM.action = { [weak self] in
//                    self?.changeSelection(vm)
//                    switch self?.pageIndex {
//                        case 0: self?.initBarCharts(year: year)
//                        case 1: self?.initPieCharts(year: year)
//                        default: break
//                    }
//                    self?.changePeriodSubject.send()
//                }
//                suggestions.append(vm)
//            }
//            barChartSuggestion = vm
//            pieChartSuggestion = vm
//            self.suggestions = suggestions
//        }
//
    }
}
