//
//  DocumentView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import UIKit

extension DocumentView {
    final class ViewModel: BasicViewModel {
        let typeLabelVM = BasicLabel.ViewModel()
        let dateLabelVM = BasicLabel.ViewModel()
        let detailsLabelVM = BasicLabel.ViewModel()
        let detailVM = DetailsView.ViewModel()
        let attachImageVM = BasicImageView.ViewModel(image: UIImage(named: "attach_ic"))
        let moreImageVM = BasicImageView.ViewModel(image: UIImage(named: "more_ic"))
        @Published var shouldShowAttention = false
        
        unowned let document: Document
        
        init(document: Document) {
            self.document = document
            super.init()
            typeLabelVM.textValue = .text(document.rawType)
            if let startDate = document.startDate,
               let endDate = document.endDate {
                let startString = startDate.toString(.ddMMyy)
                let endString = endDate.toString(.ddMMyy)
                dateLabelVM.textValue = .text("С_по".localized(startString, endString))
            }
            let photoCount = RealmManager<Photo>().read()
                .filter({ $0.documentId == document.id })
            attachImageVM.isHidden = photoCount.isEmpty
    
            guard let days = document.days else { return }
            shouldShowAttention = days < 30 && days > 0
        }
    }
}
