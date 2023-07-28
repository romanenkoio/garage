//
//  BasicBarChart+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.07.23.
//

import Foundation
import DGCharts

typealias BarChartItem = [(id: String, XaxisValue: Int, YaxisValue: Int)]

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
                let sum = barItems.filter({ $0.XaxisValue-1 == index }).map({ $0.YaxisValue }).reduce(0, +)
                dataEntries.append(BarChartDataEntry(x: Double(index), y: Double(sum)))
            }
            
            let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
            let data = BarChartData(dataSet: chartDataSet)

            self.barChartData = data
        }
    }
}
