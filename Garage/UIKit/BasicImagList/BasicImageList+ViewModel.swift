//
//  BasicIMageScrollableView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.06.23.
//

import Foundation
import UIKit
import Combine

extension BasicImageListView {
    class ViewModel: BasicViewModel, HasChangable {
        var hasChange: Bool = false
        var hasChangeSubject: CurrentValueSubject<Bool, Never> = .init(false)
        var checkedValue: [UIImage]?
    
        private(set) var descriptionLabelVM: BasicLabel.ViewModel?
       
//        Don't use directly for set images, use set function instead
        @Published var items: [UIImage] = [] {
            didSet {
                checkChanged(items)
            }
        }
        @Published var selectedIndex: Int?
        @Published var editingEnabled: Bool?
        
        var description: String? {
            didSet {
                guard let description else {
                    descriptionLabelVM?.isHidden = true
                    return
                }
                descriptionLabelVM?.textValue = .text(description)
            }
        }
        
        init(
            descriptionLabelVM: BasicLabel.ViewModel? = .init(),
            editingEnabled: Bool? = false,
            images: [UIImage] = []
        ) {
            self.editingEnabled = editingEnabled
            self.descriptionLabelVM = descriptionLabelVM
            self.items = images
            super.init()
        }
        
        func didAddedImage(_ image: UIImage) {
            self.items.append(image)
        }
        
        func set(_ images: [UIImage]) {
            self.items = images
            self.checkedValue = images
        }
        
        deinit {
            print("deinit BasicImageListView.ViewModel")
        }
    }
}
