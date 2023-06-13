//
//  PhotoVcNavigationView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 13.06.23.
//

import Foundation

extension PhotoVcNavigationView {
    class ViewModel: BasicViewModel {
        var photoCountLabelVM: BasicLabel.ViewModel?
        var closeButtonVM: BasicButton.ViewModel?
        
        init(
            photoCountLabelVM: BasicLabel.ViewModel? = nil,
            closeButtonVM: BasicButton.ViewModel? = nil
        ) {
            self.photoCountLabelVM = photoCountLabelVM
            self.closeButtonVM = closeButtonVM
        }
        
        var text: String {
            get {photoCountLabelVM?.text ?? ""}
            set {photoCountLabelVM?.text = newValue
                print(newValue)
            }
        }
    }
}
