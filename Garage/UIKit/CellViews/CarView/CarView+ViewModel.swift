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
        @Published private(set) var image: UIImage?
        
        init(
            brand: String,
            model: String? = nil,
            image: UIImage? = nil
        ) {
            self.image = image
            self.brandLabelVM.text = brand
            self.modelLabelVM.text = model
        }
        
        func setImage(_ image: UIImage) {
            self.image = image
        }
    }
}
