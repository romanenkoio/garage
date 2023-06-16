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
        var descriptionLabelVM: BasicLabel.ViewModel?
       
        @Published var items: [UIImage] = []
        @Published var selectedIndex: Int?
        @Published var editingEnabled: Bool?
        
        var description: String? {
            didSet {
                guard let description else {
                    descriptionLabelVM?.isHidden = true
                    return
                }
                descriptionLabelVM?.text = description
            }
        }
        
        init(
            descriptionLabelVM: BasicLabel.ViewModel? = .init(),
            
            editingEnabled: Bool? = false
        ) {
            self.editingEnabled = editingEnabled
            self.descriptionLabelVM = descriptionLabelVM
            super.init()
        }
        
        func didAddedImage(_ image: UIImage) {
            self.items.append(image)
 
        }
    }
}

