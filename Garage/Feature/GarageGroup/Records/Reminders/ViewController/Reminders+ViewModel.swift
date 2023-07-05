//
//  Reminders+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 5.07.23.
//  
//

import UIKit

extension RemindersViewController {
    final class ViewModel: BasicViewModel {
        
        private(set) unowned var car: Car

        let tableVM = BasicTableView.GenericViewModel<Record>()
        
        init(car: Car) {
            self.car = car
            super.init()
            tableVM.isHiddenButton = true
        }
        
        func readRecords() {
            let records = RealmManager<Record>().read()
            tableVM.setCells(records)
        }
    }
}
