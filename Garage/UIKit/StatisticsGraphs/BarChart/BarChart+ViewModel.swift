//
//  BasicBarChart+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.07.23.
//

import Foundation
import DGCharts
import Combine

typealias BarChartItem = [(id: String, XaxisValue: Int, YaxisValue: Int)]

extension BarChart {
    
    class ViewModel: BasicViewModel {
        var descriptionLabelVM = BasicLabel.ViewModel()
        @Published var records: [Record] = .empty
        var year: Int?
    }
    
    class GenericViewModel<T: Equatable>: ViewModel {
        typealias Item = T
        
        @Published var barChartData = BarChartData()
        @Published private(set) var items: [Item] = []

        private(set) var barItems: BarChartItem = []

        func setItems(
            list: [Item],
            title: TextValue,
            barItems: ([Item]) -> BarChartItem
        ) {
            self.items = list
            self.barItems = barItems(list)
            descriptionLabelVM.textValue = title
            makeItems()
        }
        
        func makeItems() {
            var dataEntries: [BarChartDataEntry] = []
            
            DateFormatter().shortMonthSymbols.enumerated().forEach { index, value in
                let sum = barItems.filter({ $0.XaxisValue - 1 == index }).map({ $0.YaxisValue }).reduce(0, +)
                dataEntries.append(BarChartDataEntry(x: Double(index), y: Double(sum)))
            }
            
            let chartDataSet = BarChartDataSet(entries: dataEntries, label: .empty.appendCurrency())
            chartDataSet.highlightColor = AppColors.green
            chartDataSet.highlightAlpha = 1
            chartDataSet.colors = [.init(hexString: "dbdadb")]
            chartDataSet.valueFont = .custom(size: 12, weight: .regular)
            chartDataSet.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: chartDataSet)
            self.barChartData = data
        }
    }
}
