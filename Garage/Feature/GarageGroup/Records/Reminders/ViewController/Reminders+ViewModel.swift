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

        let tableVM = BasicTableView.SectionViewModel<Reminder>()
        private(set) var headers: [DateHeaderView.ViewModel] = .empty
        var completeReminder: ((Reminder) -> Void)?
        var didLayoutSubviews: ((UITableView)->())?
        
        init(car: Car) {
            self.car = car
            super.init()
            tableVM.isHiddenButton = true
            
            tableVM.setupEmptyState(
                type: .small,
                labelVM: .init(.text("Напоминаний нет")),
                sublabelVM: .init(.text("Запланированных задач пока нет, но их можно добавить")),
                addButtonVM: .init(),
                image: nil
            )
            
            readReminders()
        }
        
        func readReminders() {
            let reminders = car.reminders.filter({ !$0.isDone })
            let dates = Set(reminders.compactMap{ $0.date }).sorted(by: <)
            let components = Set(dates.compactMap({ $0.recordComponents }))

            var cells: [[Reminder]] = .empty
            components.forEach { component in
                let setionCells = reminders.filter({ $0.date.recordComponents == component })
                cells.append(setionCells)
            }
           
            headers = components.compactMap({ DateHeaderView.ViewModel(date: $0) })
            
            tableVM.setCells(cells)
        }
    }
}
