//
//  Statistics+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//  
//

import UIKit
import Combine
extension ChartsViewController {
    final class ViewModel: BasicViewModel {
        
        let chartsViewVM: ChartsView.ViewModel?
        var tableVM = BasicTableView.SectionViewModel<RecordView.ViewModel>()
        var barChartRecords: [Record] = .empty
        var pieChartRecords: [Record] = .empty
        
        private(set) var headers: [DateHeaderView.ViewModel] = .empty
        
        @Published var suggestions: [SuggestionView.ViewModel] = []
        @Published var years: [Int] = .empty
        unowned let car: Car
        
        init(car: Car) {
            self.car = car
            chartsViewVM = .init(car: car)
            self.years = Array(Set(car.records.compactMap({ $0.date.components.year })).sorted(by: >))
            super.init()
            tableVM.isHiddenButton = true
            
            tableVM.setupEmptyState(
                type: .small,
                labelVM: .init(),
                sublabelVM: .init(.text("Выберите период")),
                addButtonVM: .init(),
                image: nil
            )

            initBarSuggestions()
            
            chartsViewVM?.$pageIndex
                .sink(receiveValue: {[weak self] index in
                    guard let self else { return }
                    switch index {
                        case 0:
                            guard let barChartSuggestion = self.chartsViewVM?.barChartSuggestion else { return }
                            self.changeSelection(barChartSuggestion)
                            self.createRecords(from: barChartRecords)
                            
                        case 1:
                            guard let pieChartSuggestion = chartsViewVM?.pieChartSuggestion else { return }
                            self.changeSelection(pieChartSuggestion)
                            self.createRecords(from: pieChartRecords)
                            
                        default: break
                    }
                })
                .store(in: &cancellables)
        }
        
        func initBarSuggestions() {
            var suggestions: [SuggestionView.ViewModel] = .empty
            let vm = SuggestionView.ViewModel(labelVM: .init(.text("Весь период")))
            vm.backgroundColor = .white
            vm.labelVM.action = { [weak self] in
                guard let self else { return }
                self.changeSelection(vm)
                switch self.chartsViewVM?.pageIndex {
                    case 0:
                        self.chartsViewVM?.initBarCharts()
                        self.chartsViewVM?.barChartSuggestion = vm
                        self.initTableView()
                    case 1:
                        self.chartsViewVM?.initPieCharts()
                        self.chartsViewVM?.pieChartSuggestion = vm
                        self.initTableView()
                    default: break
                }
                
                self.chartsViewVM?.changePeriodSubject.send()
            }
            suggestions.append(vm)
            vm.isSelected = true
            
            years.forEach { [weak self] year in
                let vm = SuggestionView.ViewModel(labelVM: .init(.text(year.toString())))
                vm.backgroundColor = .white
                vm.labelVM.action = { [weak self] in
                    guard let self else { return }
                    self.changeSelection(vm)
                    
                    switch self.chartsViewVM?.pageIndex {
                        case 0:
                            self.chartsViewVM?.initBarCharts(with: year)
                            self.chartsViewVM?.barChartSuggestion = vm
                            self.initTableView(with: year)
                        case 1:
                            self.chartsViewVM?.initPieCharts(with: year)
                            self.chartsViewVM?.pieChartSuggestion = vm
                            self.initTableView(with: year)
                        default: break
                    }
                    
                    
                    self.chartsViewVM?.changePeriodSubject.send()
                }
                suggestions.append(vm)
            }
            
            chartsViewVM?.barChartSuggestion = vm
            chartsViewVM?.pieChartSuggestion = vm
            self.suggestions = suggestions
        }
        
        func changeSelection(_ selected: SuggestionView.ViewModel) {
            suggestions.forEach({ $0.isSelected = false })
            
            switch chartsViewVM?.pageIndex {
                case 0:
                    selected.isSelected = true
                case 1:
                    selected.isSelected = true
                default: break
            }
        }
        
        func initTableView(with year: Int? = nil) {
            var data = car.records
            if let year {
                data = car.records.filter({$0.date.components.year == year})
            } else {
                data = car.records
            }
            
            switch chartsViewVM?.pageIndex {
                case 0:
                    createRecords(from: data)
                    barChartRecords = data
                case 1:
                    createRecords(from: data)
                    pieChartRecords = data
                default: break
            }
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
