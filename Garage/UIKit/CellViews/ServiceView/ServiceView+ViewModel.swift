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
        let phoneLabelVM = BasicLabel.ViewModel()
        let adressLabelVM = BasicLabel.ViewModel()
        let specializationLabelVM = BasicLabel.ViewModel()
        
        init(service: Service) {
            nameLabelVM.text = service.name
            phoneLabelVM.text = service.phone
            adressLabelVM.text = service.adress
            specializationLabelVM.text = service.specialisation
        }
    }
}
