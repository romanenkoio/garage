//
//  PieChart+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 29.07.23.
//

import Foundation
import DGCharts
import Combine

typealias PieChartItem = [(value: Int, category: String)]

extension PieChart {
    
    class ViewModel: BasicViewModel {
        var descriptionLabelVM = BasicLabel.ViewModel()
        @Published var records: [Record] = .empty
        var year: Int?
    }
    
    class GenericViewModel<T: Equatable>: ViewModel {
        typealias Item = T
        
        @Published var pieChartData = PieChartData()
        @Published private(set) var items: [Item] = []
        @Published var dataEntries: [PieChartDataEntry] = .empty
        private(set) var pieItems: PieChartItem = []

        func setItems(
            list: [Item],
            title: TextValue,
            pieItems: ([Item]) -> PieChartItem
        ) {
            self.items = list
            self.pieItems = pieItems(list)
            descriptionLabelVM.textValue = title
            makeItems()
        }
        
        func makeItems() {
            var categories: [String] = .empty
            categories = Array(Set(pieItems.map({$0.category})))
            dataEntries.removeAll()
            categories.forEach {[weak self] category in
                guard let self else { return }
                let sum = self.pieItems.filter({$0.category == category}).map({$0.value}).reduce(0, +)
                self.dataEntries.append(PieChartDataEntry(value: Double(sum), label: category, data: category))
            }
            
            let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: .empty)
            pieChartDataSet.highlightColor = .lightGray.withAlphaComponent(0.6)
            pieChartDataSet.colors = [.blue, .red, .gray,.green,.yellow,.systemPink]
            pieChartDataSet.valueFont = .custom(size: 12, weight: .regular)
            pieChartDataSet.drawValuesEnabled = false
            
            let data = PieChartData(dataSet: pieChartDataSet)
            self.pieChartData = data
        }
    }
}

