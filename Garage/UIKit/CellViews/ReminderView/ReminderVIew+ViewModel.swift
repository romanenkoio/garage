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
        let completeButton = BasicButton.ViewModel(title: "Выполнить", style: .complete)

        var reminder: Reminder

        init(reminder: Reminder) {
            infoLabelVM.textValue = .text(reminder.short)
            dateLabelVM.textValue = .text(reminder.date.toString(.ddMMyy))
            self.reminder = reminder
        }
    }
}
