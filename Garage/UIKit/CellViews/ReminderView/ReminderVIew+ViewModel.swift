//
//  ReminderVIew+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 9.07.23.
//

import Foundation

extension ReminderView {
    final class ViewModel: BasicViewModel {

        var infoLabelVM = BasicLabel.ViewModel()
        let dateLabelVM = BasicLabel.ViewModel()
        
        unowned var reminder: Reminder
        
        init(reminder: Reminder) {
            infoLabelVM.text = reminder.short
            dateLabelVM.text = reminder.date.toString(.ddMMyy)
            self.reminder = reminder
        }
    }
}
