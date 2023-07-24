//
//  CarPinView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 25.07.23.
//

import UIKit

extension CarPinView {
    final class ViewModel: BasicViewModel {
        let pinImageVM = BasicImageView.ViewModel(
            image: UIImage(named: "clear_pin_ic"),
            mode: .scaleAspectFit
        )
        var сarImageVM =  BasicImageView.ViewModel(data: nil, mode: .scaleAspectFill)
        
        init(car: Car) {
            сarImageVM.set(from: car.images.first, placeholder: UIImage(named: "logo_placeholder"))
        }
    }
}
