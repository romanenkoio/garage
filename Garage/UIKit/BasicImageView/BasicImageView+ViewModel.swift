//
//  BasicImageView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 15.07.23.
//

import UIKit

extension BasicImageView {
    final class ViewModel: BasicViewModel {
        @Published var image: UIImage?
        @Published var mode: UIImageView.ContentMode = .scaleAspectFit
        
        init(
            image: UIImage? = nil,
            mode: UIImageView.ContentMode = .scaleAspectFit
        ) {
            self.image = image
            self.mode = mode
        }
    }
}
