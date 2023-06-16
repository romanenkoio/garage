//
//  BasicImageView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 10.06.23.
//

import UIKit

extension BasicImageButton {
    class ViewModel: BasicViewModel {
        var buttonVM: BasicButton.ViewModel?
        
        @Published
        var buttonStyle: ButtonStyle?
        @Published
        var image: UIImage?
        @Published
        var action: Completion?
        @Published
        var style: ImageViewStyle
        
        init(
            action: Completion? = nil,
            style: ImageViewStyle = .empty,
            image: UIImage? = nil,
            buttonVM: BasicButton.ViewModel? = nil
        ) {
            self.action = action
            self.buttonVM = buttonVM
            self.style = style
            self.image = image
            self.buttonStyle = buttonVM?.style
        }
    }
}
