//
//  CarCellPhotoCollection+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.07.23.
//

import UIKit

extension CarPhotoCollection {
    class ViewModel: BasicViewModel {
        let collectionVM = BasicCollectionView.GenericViewModel<UIImage>()
        
        @Published
        var images: [UIImage]
        
        init(images: [UIImage], imagePlaceholder: UIImage? = nil) {
            self.images = images
            super.init()
            makeCells()
            
            collectionVM.setupEmptyState(labelVM: .init(), image: imagePlaceholder)
        }
        
        func makeCells() {
//            if images.isEmpty {
//                let placeholder = [UIImage(named: "car_placeholder")!]
//                collectionVM.setCells(placeholder)
//            } else {
                collectionVM.setCells(images)
//            }
        }
    }
}
