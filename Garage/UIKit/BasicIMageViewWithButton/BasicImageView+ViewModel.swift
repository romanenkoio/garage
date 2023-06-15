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
        
        init(
            action: Completion? = nil,
            image: UIImage? = nil,
            buttonVM: BasicButton.ViewModel? = nil
        ) {
            self.action = action
            self.buttonVM = buttonVM
            self.image = image
            self.buttonStyle = buttonVM?.style
        }
    }
}
