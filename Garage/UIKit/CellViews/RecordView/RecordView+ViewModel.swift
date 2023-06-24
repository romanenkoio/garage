//
//  RecordView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import Foundation

extension RecordView {
    final class ViewModel: BasicViewModel {
        private(set) var record: Record
        var infoLabelVM = BasicLabel.ViewModel()
        let dateLabelVM = BasicLabel.ViewModel()
        
        init(record: Record) {
            self.record = record
            infoLabelVM.text = record.carID
            dateLabelVM.text = record.date.formatData(formatType: .ddMMyy)
        }
    }
}
