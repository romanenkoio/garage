//
//  FullSizePhotoController+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 12.06.23.
//  
//

import UIKit
import Combine

extension FullSizePhotoViewController {
    final class ViewModel: BasicViewModel {
        let collectionVM = BasicCollectionView.GenericViewModel<UIImage>()
        var navViewVM: PhotoVcNavigationView.ViewModel?

        @Published
        var images: [UIImage]

        
        init(images: [UIImage]) {
            self.images = images
            super.init()
            makeCells()
        }
        
        func makeCells() {
            collectionVM.setCells(images)
        }
    }
}
