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
        var images = [UIImage]()
        let record: Record
        
        init(record: Record) {
            self.record = record
            infoLabelVM.text = record.short
            dateLabelVM.text = record.date.toString(.ddMMyy)
            
            let data = RealmManager<Photo>().read()
                .filter({ $0.recordId == record.id })
                .map({ $0.image })
            
            let imgs = data.compactMap({ _ in  UIImage(named: "service")})
            imageListVM.set(imgs)
            
            super.init()
            
            if !images.isEmpty {
                imageListVM.set(images)
                print("Set from cache")
            } else {
                Task(priority: .background, operation: { [weak self] in
                    guard let self else { return }
                    let images = data.compactMap({ UIImage(data: $0 )})
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        imageListVM.set(images)
                        imageListVM.editingEnabled = false
                        self.images = images
                    }
                })
                print("Set from realm")
            }
        }
    }
}
