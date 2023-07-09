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
        
        init(images: [UIImage]) {
            self.images = images
            super.init()
            makeCells()
        }
        
        func makeCells() {
            if images.isEmpty {
                let placeholder = [UIImage(named: "car_placeholder")!]
                collectionVM.setCells(placeholder)
            } else {
                collectionVM.setCells(images)
            }
        }
    }
}
