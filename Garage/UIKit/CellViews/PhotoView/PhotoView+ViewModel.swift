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
        @Published
        var singleTapAction: Completion
        @Published
        var zoomAction: Completion
        
        
        init(
            singleTapAction: @escaping Completion,
            zoomAction: @escaping Completion,
            image: UIImage
        ) {
            self.singleTapAction = singleTapAction
            self.zoomAction = zoomAction
            self.image = image
        }
    }
}
