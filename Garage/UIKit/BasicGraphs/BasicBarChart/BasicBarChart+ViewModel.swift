//
//  BasicBarChart+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.07.23.
//

import Foundation
import DGCharts
import RealmSwift
typealias BarChartItem = [(id: String, month: Int, cost: Int)]

extension BasicBarChart {
    
    class ViewModel: BasicViewModel {
        var descriptionLabelVM = BasicLabel.ViewModel()
        
        func setupLabel(descriptionLabel: BasicLabel.ViewModel) {
            self.descriptionLabelVM = descriptionLabel
        }
    }
    
    
    class GenericViewModel<T: Equatable>: ViewModel {
        typealias Item = T
        
        @Published var barChartData = BarChartData()
        
        @Published private(set) var items: [Item] = []
        private(set) var barItems: BarChartItem = []
        
        func setItems(_ list: [Item],
                      barItems: ([Item]) -> BarChartItem
                  ) {
                      self.items = list
                      self.barItems = barItems(list)
                      makeItems()
                  }
        
        func makeItems() {
            var dataEntries: [BarChartDataEntry] = []
            
            DateFormatter().shortMonthSymbols.enumerated().forEach { index, value in
                var sum = 0
                self.barItems.forEach { item in
                    if index == item.month {
                        sum += item.cost
                    }
                }
                dataEntries.append(BarChartDataEntry(x: Double(index), y: Double(sum)))
            }
            
            let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
            let data = BarChartData(dataSet: chartDataSet)

            self.barChartData = data
        }
    }
}
