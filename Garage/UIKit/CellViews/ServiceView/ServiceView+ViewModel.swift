//
//  ServiceView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//

import Foundation

extension ServiceView {
    final class ViewModel: BasicViewModel {
        let nameLabelVM = BasicLabel.ViewModel()
        let adressLabelVM = BasicLabel.ViewModel()
        let detailsLabelVM = BasicLabel.ViewModel()
        
        init(service: Service) {
            nameLabelVM.text = service.name
            adressLabelVM.text = service.adress
            detailsLabelVM.text = "Смотреть детали"
        }
    }
}
