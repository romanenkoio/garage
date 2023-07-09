//
//  CarCellPhotoView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.07.23.
//

import UIKit

extension CarCellPhotoView {
    class ViewModel: BasicViewModel {
        @Published
        var image: UIImage
        
        init(image: UIImage) {
            self.image = image
        }
    }
}
