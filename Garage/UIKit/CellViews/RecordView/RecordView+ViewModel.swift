//
//  RecordView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import UIKit

extension RecordView {
    final class ViewModel: BasicViewModel {
        
        var infoLabelVM = BasicLabel.ViewModel()
        let dateLabelVM = BasicLabel.ViewModel()
        var imageListVM = BasicImageListView.ViewModel(editingEnabled: false)
                
        init(record: Record) {
            infoLabelVM.text = record.short
            dateLabelVM.text = record.date.toString(.ddMMyy)
            
            super.init()
            
            Task(priority: .background, operation: { [weak self] in
                guard let self else { return }
                let images = await record.images.compactMap({ UIImage(data: $0 )})
                imageListVM.set(images)
                imageListVM.editingEnabled = false
            })
        }
    }
}
