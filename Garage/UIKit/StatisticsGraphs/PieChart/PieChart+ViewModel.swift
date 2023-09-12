//
//  PieChart+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 29.07.23.
//

import UIKit
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
            pieItems: ([Item]) -> PieChartItem
        ) {
            self.items = list
            self.pieItems = pieItems(list)
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
            pieChartDataSet.colors = PieChartColors.elementColors
            pieChartDataSet.valueFont = .custom(size: 12, weight: .regular)
            pieChartDataSet.drawValuesEnabled = false
            
            let data = PieChartData(dataSet: pieChartDataSet)
            self.pieChartData = data
        }
    }
    
   fileprivate struct PieChartColors {
        static var elementColors: [UIColor] = [
            UIColor.init(hexString: "#636872"),
            UIColor.init(hexString: "#DCA2F6"),
            UIColor.init(hexString: "#EEC865"),
            UIColor.init(hexString: "#E17256"),
            UIColor.init(hexString: "#8BE5C9"),
            UIColor.init(hexString: "#6795DC"),
            UIColor.init(hexString: "#EE87C6"),
            UIColor.init(hexString: "#A4CA6F"),
            UIColor.init(hexString: "#78D6FF"),
            UIColor.init(hexString: "#A08FDE"),
            UIColor.init(hexString: "#D3DCFF"),
        ]
    }
}


