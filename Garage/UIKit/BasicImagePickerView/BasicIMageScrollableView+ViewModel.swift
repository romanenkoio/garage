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
       
        @Published var items: [UIImage] = []
        @Published var selectedIndex: Int?
        
        @Published var editingEnabled: Bool? {
            didSet {
                changeEditButtonTitle(with: editingEnabled)
            }
        }
        
        var description: String? {
            didSet {
                descriptionLabelVM?.text = description
            }
        }
        
        var editButtonEnabled: Bool? {
            didSet {
                if let editButtonEnabled {
                    editButtonVM?.isHidden = !editButtonEnabled
                }
            }
        }
        
        var editButtonTitle: String? {
            didSet {
                editButtonVM?.title = editButtonTitle
            }
        }
        
        var doneEditButtonTitle: String?
        
        init(
            descriptionLabelVM: BasicLabel.ViewModel? = .init(),
            editButtonVM: BasicButton.ViewModel? = .init(),
            editingEnabled: Bool? = false
        ) {
            self.editingEnabled = editingEnabled
            self.descriptionLabelVM = descriptionLabelVM
            self.editButtonVM = editButtonVM
            super.init()
            didTapEditButton()
        }
        
        func didAddedImage(_ image: UIImage) {
            self.items.append(image)
 
        }
        
        private func didTapEditButton() {
            editButtonVM = .init(
                style: .basicDarkTitle,
                action: .touchUpInside {[weak self] in
                    self?.editingEnabled?.toggle()
                }
            )
        }
        
        private func changeEditButtonTitle(with value: Bool?) {
            if let value {
                editButtonVM?.title = value ? doneEditButtonTitle : editButtonTitle
            }
        }
        
    }
}

