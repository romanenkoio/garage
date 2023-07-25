//
//  ActionImage+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 8.06.23.
//

import UIKit

extension ActionImage {
    final class ViewModel: BasicViewModel {
        @Published
        var action: Completion?
        @Published
        var image: UIImage?
        @Published
        var isEnabled: Bool
        @Published
        var isHidden: Bool = false
        
        init(
            action: Completion? = nil,
            image: UIImage? = UIImage(systemName: "list.dash"),
            isEnable: Bool = true
        ) {
 
            self.action = action
            self.image = image
            self.isEnabled = isEnable
        }
    }
}
