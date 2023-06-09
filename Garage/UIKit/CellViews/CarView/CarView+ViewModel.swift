//
//  CarView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit

extension CarView {
    class ViewModel: BasicViewModel {
        let brandLabelVM = BasicLabel.ViewModel()
        let modelLabelVM = BasicLabel.ViewModel()
        let logoURL: String
        
        init(
            brand: String,
            model: String? = nil,
            logoURL: String
        ) {
            self.brandLabelVM.text = brand
            self.modelLabelVM.text = model
            self.logoURL = logoURL
        }
    }
}
