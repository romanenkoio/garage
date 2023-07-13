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
        let documentPhotoCollectionVM: CarPhotoCollection.ViewModel
        @Published var shouldShowAttention = false
        @Published var cells: [UIImage] = []
        
        init(document: Document) {
            documentPhotoCollectionVM = .init(images: document.photos)
            super.init()
            typeLabelVM.textValue = .text(document.rawType)
            if let startDate = document.startDate,
               let endDate = document.endDate {
                let startString = startDate.toString(.ddMMyy)
                let endString = endDate.toString(.ddMMyy)
                dateLabelVM.textValue = .text("С \(startString) по \(endString)")
            }
            
            detailsLabelVM.textValue = .text("Смотреть детали")
        }
    }
}
