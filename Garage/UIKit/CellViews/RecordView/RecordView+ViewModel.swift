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
        let record: Recordable
        let attachImageVM = BasicImageView.ViewModel(image: UIImage(named: "attach_ic"))
        let moreImageVM = BasicImageView.ViewModel(image: UIImage(named: "more_ic"))
        
        init(record: Recordable) {
            self.record = record
            infoLabelVM.textValue = .text(record.short)
            dateLabelVM.textValue = .text(record.date.toString(.ddMMMMyyyy))
            
            let photoCount = RealmManager<Photo>().read()
                .filter({ $0.recordId == record.id })
            attachImageVM.isHidden = photoCount.isEmpty
        }
        
        deinit {
//            print("Deinit \(self.self)")
        }
    }
}
