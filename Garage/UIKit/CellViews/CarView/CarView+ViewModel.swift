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
        var image: UIImage? = UIImage(systemName: "car")

        init(
            car: Car
        ) {
            self.brandLabelVM.text = car.brand
            self.modelLabelVM.text = car.model
            if let data = car.imageData,
               let image = UIImage(data: data)
            {
                self.image = image
            }
        }
    }
}
