//
//  NavBarButton+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 8.06.23.
//

import UIKit

extension NavBarButton {
    final class ViewModel: BasicViewModel {
        @Published var action: Action?
        @Published var image: UIImage?
        
        init(
            action: Action? = nil,
            image: UIImage? = nil
        ) {
            self.action = action
            self.image = image
        }
    }
}
