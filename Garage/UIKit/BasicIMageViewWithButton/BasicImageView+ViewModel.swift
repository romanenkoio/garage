//
//  BasicImageView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 10.06.23.
//

import UIKit

extension BasicImageViewWithButton {
    class ViewModel: BasicViewModel {
        var buttonVM: BasicButton.ViewModel
        @Published var image: UIImage
        @Published var buttonStyle: ButtonStyle
        
        init(image: UIImage, buttonStyle: ButtonStyle, buttonVM: BasicButton.ViewModel) {
            self.buttonVM = buttonVM
            self.image = image
            self.buttonStyle = buttonStyle
            buttonVM.style = buttonStyle
        }
    }
}
