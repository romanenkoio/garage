//
//  DocumentView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import Foundation

extension DocumentView {
    final class ViewModel: BasicViewModel {
        let typeLabelVM = BasicLabel.ViewModel()
        let dateLabelVM = BasicLabel.ViewModel()
        let detailsLabelVM = BasicLabel.ViewModel()
        let photoListVM = BasicImageListView.ViewModel()
        let detailVM = DetailsView.ViewModel()
        
        init(document: Document) {
            typeLabelVM.text = document.rawType
            if let startDate = document.startDate,
               let endDate = document.endDate {
                let startString = startDate.toString(.ddMMyy)
                let endString = endDate.toString(.ddMMyy)
                dateLabelVM.text = "С \(startString) по \(endString)"
            }
            
            photoListVM.set(document.photos)
            detailsLabelVM.text = "Смотреть детали"
        }
    }
}
