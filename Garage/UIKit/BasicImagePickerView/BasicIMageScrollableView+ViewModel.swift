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
        var editButtonVM: BasicButton.ViewModel?
        @Published var contentType = BasicImageListViewType.addPhoto
        @Published var items: [UIImage] = []
        @Published var selectedIndex: Int?
        @Published var editingEnabled: Bool?
        
        init(descriptionLabelVM: BasicLabel.ViewModel? = nil, editingEnabled: Bool? = false) {
            self.editingEnabled = editingEnabled
            self.descriptionLabelVM = descriptionLabelVM
            
            super.init()
            didTapEditButton()
        }
        
        func didAddedImage(_ image: UIImage) {
            self.items.append(image)
 
        }
        
        private func didTapEditButton() {
            editButtonVM = .init(
                title: "Редактировать",
                style: .nonStyle,
                action: .touchUpInside {
                    self.editingEnabled?.toggle()
                }
            )
        }
        
    }
}

