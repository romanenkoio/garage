//
//  RecordView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import Foundation

extension RecordView {
    final class ViewModel: BasicViewModel {

        var infoLabelVM = BasicLabel.ViewModel()
        let dateLabelVM = BasicLabel.ViewModel()
        
        @Published var reminder: Reminder?
        
        init(record: Record) {
            infoLabelVM.text = record.short
            dateLabelVM.text = record.date.toString(.ddMMyy)
        }
        
        init(reminder: Reminder) {
            infoLabelVM.text = reminder.short
            dateLabelVM.text = reminder.date.toString(.ddMMyy)
            self.reminder = reminder
        }
    }
}
