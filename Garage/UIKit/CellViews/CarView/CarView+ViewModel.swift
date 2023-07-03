//
//  CarView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit

extension CarView {
    class ViewModel: BasicViewModel {
        let detailsVM = DetailsView.ViewModel()
        let brandLabelVM = BasicLabel.ViewModel()
        let plannedLabelVM = BasicLabel.ViewModel()
        let atteentionLabelVM = BasicLabel.ViewModel()
        @Published var image: UIImage?
        
        init(
            car: Car
        ) {
            brandLabelVM.text = "\(car.brand) \(car.model)"
            atteentionLabelVM.text = "Просрочена медицинская справка"
            plannedLabelVM.text = "Нет запланированных событий"
            if let data = car.imageData,
               let image = UIImage(data: data) {
                self.image = image
            }
        }
    }
}
