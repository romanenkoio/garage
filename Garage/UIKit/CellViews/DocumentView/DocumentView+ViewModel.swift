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
            documentPhotoCollectionVM = .init(images: document.photos, imagePlaceholder: UIImage(named: "car_placeholder")!)
            super.init()
            typeLabelVM.text = document.rawType
            if let startDate = document.startDate,
               let endDate = document.endDate {
                let startString = startDate.toString(.ddMMyy)
                let endString = endDate.toString(.ddMMyy)
                dateLabelVM.text = "С \(startString) по \(endString)"
            }
            
            detailsLabelVM.text = "Смотреть детали"
        }
    }
}
