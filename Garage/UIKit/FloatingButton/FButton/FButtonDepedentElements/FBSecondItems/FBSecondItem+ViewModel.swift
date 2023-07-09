//
//  FBSecondItem+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.07.23.
//

import UIKit

extension FloatingButtonSecondItem {
    class ViewModel: BasicViewModel {
        var tappableLabelVM: TappableLabel.ViewModel
        
        @Published
        var image: UIImage?
        
        init(tappableLabelVM: TappableLabel.ViewModel, image: UIImage? = nil) {
            self.tappableLabelVM = tappableLabelVM
            self.image = image
            super.init()
        }
    }
}
