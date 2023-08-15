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
        var barDescriptionLabelVM = BasicLabel.ViewModel()
        var pieDescriptionLabelVM = BasicLabel.ViewModel()
        
        @Published var suggestions: [SuggestionView.ViewModel] = []
        var changePeriodSubject: PassthroughSubject<Void, Never> = .init()
        
        @Published var pageIndex = 0 {
            didSet {
                switch pageIndex {
                    case 0:
                        if let barChartSuggestion {
                            changeSelection(barChartSuggestion)
                        }
                    case 1:
                        if let pieChartSuggestion {
                            changeSelection(pieChartSuggestion)
                        }
                    default: break
                }
            }
        }
        
        var records: [Record]
        @Published var years: [Int] = .empty
        
        unowned let car: Car
        
        init(car: Car) {
            self.car = car
            records = RealmManager().read().filter({ $0.carID == car.id })
         
            self.years = Array(Set(records.compactMap({ $0.date.components.year })).sorted(by: >))
            super.init()
            initBarCharts()
            initPieCharts()
            initBarSuggestions()
        }
        
        func initBarCharts(year: Int? = nil) {
            var data = records
            var title: TextValue = .text("Расходы за всё время".localized)
            if let year {
                barChartVM.year = year
                data = records.filter({ $0.date.components.year == year })
                title = .text("Расходы_год".localized(year))
            } else {
                barChartVM.year = nil
            }
            
            barDescriptionLabelVM.textValue = title
            barChartVM.setItems(
                list: data) { items in
                    return items.map({($0.id, $0.date.components.month ?? 0, $0.cost ?? 0)})
                }
        }
        
        func initPieCharts(year: Int? = nil) {
            var data = records
            var title: TextValue = .text("Расходы_всё_время".localized)
            if let year {
                pieChartVM.year = year
                data = records.filter({$0.date.components.year == year})
                title = .text("Расходы_категории_год".localized(year))
            } else {
                pieChartVM.year = nil
            }
            
            pieDescriptionLabelVM.textValue = title
            pieChartVM.setItems(
                list: data) { items in
                    return items.map({($0.cost ?? 0, $0.short)})
                }
        }

                
        func initBarSuggestions() {
            var suggestions: [SuggestionView.ViewModel] = .empty
            let vm = SuggestionView.ViewModel(labelVM: .init(.text("Весь период".localized)))
            vm.labelVM.action = { [weak self] in
                self?.changeSelection(vm)
                switch self?.pageIndex {
                    case 0: self?.initBarCharts()
                    case 1: self?.initPieCharts()
                    default: break
                }
                self?.changePeriodSubject.send()
            }
            suggestions.append(vm)
            vm.isSelected = true
            
            years.forEach { [weak self] year in
                let vm = SuggestionView.ViewModel(labelVM: .init(.text(year.toString())))
                vm.labelVM.action = { [weak self] in
                    self?.changeSelection(vm)
                    switch self?.pageIndex {
                        case 0: self?.initBarCharts(year: year)
                        case 1: self?.initPieCharts(year: year)
                        default: break
                    }
                    self?.changePeriodSubject.send()
                }
                suggestions.append(vm)
            }
            barChartSuggestion = vm
            pieChartSuggestion = vm
            self.suggestions = suggestions
        }
        
        func changeSelection(_ selected: SuggestionView.ViewModel) {
            suggestions.forEach({ $0.isSelected = false })
            selected.isSelected = true
            switch pageIndex {
                case 0:
                    barChartSuggestion = selected
                case 1:
                    pieChartSuggestion = selected
                default: break
            }
        }
    }
}
