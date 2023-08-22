//
//  StatisticView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 22.08.23.
//

import Foundation

extension StatisticView {
    class ViewModel: BasicViewModel {
        
        @Published var cellValue: StatisticsType
        
        init(cellValue: StatisticsType) {
            self.cellValue = cellValue
        }
    }
}
