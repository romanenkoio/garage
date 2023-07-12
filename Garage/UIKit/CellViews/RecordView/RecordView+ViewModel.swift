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
        let imageListVM: BasicImageListView.ViewModel
                
        init(record: Record) {
            infoLabelVM.text = record.short
            dateLabelVM.text = record.date.toString(.ddMMyy)
            
            imageListVM = .init(editingEnabled: false, images: record.images)
        }
    }
}
