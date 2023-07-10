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

        let tableVM = BasicTableView.GenericViewModel<Reminder>()
        var completeReminder: ((Reminder) -> Void)?
        
        init(car: Car) {
            self.car = car
            super.init()
            tableVM.isHiddenButton = true
            
            tableVM.setupEmptyState(
                type: .small,
                labelVM: .init(text: "Напоминаний нет"),
                sublabelVM: .init(text: "Запланированных задач пока нет, но их можно добавить"),
                addButtonVM: .init(),
                image: nil
            )
            
            readReminders()
        }
        
        func readReminders() {
            tableVM.setCells(car.reminders)
        }
    }
}
