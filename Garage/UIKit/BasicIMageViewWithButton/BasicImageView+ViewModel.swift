//
//  BasicImageView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 10.06.23.
//

import UIKit

extension BasicImageButton {
    class ViewModel: BasicViewModel {
        var buttonVM: BasicButton.ViewModel
        
        @Published
        var buttonStyle: ButtonStyle
        @Published
        var image: UIImage?
        @Published
        var action: Completion
        
        init(
            action: @escaping Completion,
            image: UIImage?,
            buttonVM: BasicButton.ViewModel
        ) {
            self.action = action
            self.buttonVM = buttonVM
            self.image = image
            self.buttonStyle = buttonVM.style
        }
    }
}
