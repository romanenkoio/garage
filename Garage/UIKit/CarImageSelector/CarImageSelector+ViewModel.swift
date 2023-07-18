//
//  CarImageSelector+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 18.07.23.
//

import UIKit
import Combine

extension CarImageSelector {
    final class ViewModel: BasicViewModel {
 
        
        var logoVM: BasicImageView.ViewModel
        var action: Completion?
        
        init(image: UIImage? = UIImage(named: "car_placeholder")) {
            self.logoVM = .init(image: image, mode: .scaleAspectFill)
        }
    }
}
