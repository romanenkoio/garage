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
        
        var imagePlaceholder: UIImage?
        
        init(images: [UIImage], imagePlaceholder: UIImage? = nil) {
            self.images = images
            self.imagePlaceholder = imagePlaceholder
            super.init()
            makeCells()
            
            collectionVM.setupEmptyState(labelVM: .init(), image: imagePlaceholder)
        }
        
        func makeCells() {
            collectionVM.setCells(images)
        }
    }
}
