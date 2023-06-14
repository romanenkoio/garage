//
//  BasicIMageScrollableView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.06.23.
//

import Foundation
import UIKit

extension BasicImageListView {
    class ViewModel: BasicViewModel {
        
        @Published var contentType = BasicImageListViewType.addPhoto
        @Published var items: [UIImage] = []
        @Published var selectedIndex: Int?
        @Published var action: Completion
        
        override init() {
            self.action = {
                print("test")
            }
            super.init()
        }
        
        func didAddedImage(_ image: UIImage) {
            self.items.append(image)
            
            self.items.enumerated().forEach { index, value in
                
            }
        }

    }
}

