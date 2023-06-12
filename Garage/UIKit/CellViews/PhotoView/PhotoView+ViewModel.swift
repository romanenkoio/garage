//
//  PhotoView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 13.06.23.
//

import UIKit

extension PhotoView {
    class ViewModel: BasicViewModel {
        @Published
        var image: UIImage
        
        init(image: UIImage) {
            self.image = image
        }
    }
}
