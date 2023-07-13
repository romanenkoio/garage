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
        let detailVM = DetailsView.ViewModel()
        let callButtonVM: CallButton.ViewModel
        unowned let service: Service

        init(service: Service) {
            self.service = service
            nameLabelVM.textValue = .text(service.name)
            adressLabelVM.textValue = .text(service.adress)
            callButtonVM = .init(phone: service.phone)
        }
    }
}
