//
//  StatisticView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 22.08.23.
//

import Foundation
typealias StatModel = (Int,String?,Record?,Record?)
extension StatisticView {
    class ViewModel: BasicViewModel {
        
        @Published var cellValue: StatModel
        
        init(cellValue: StatModel) {
            self.cellValue = cellValue
        }
    }
}
