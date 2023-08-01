//
//  Statistics+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//  
//

import UIKit

extension StatisticsViewController {
    final class ViewModel: BasicViewModel {
        
        let flipviewVM: FlipView.ViewModel?

        unowned let car: Car
        
        
        init(car: Car) {
            self.car = car
            flipviewVM = .init(car: car)
            super.init()

            // MARK: Init BarCharts
            
        }
        

    }
}
