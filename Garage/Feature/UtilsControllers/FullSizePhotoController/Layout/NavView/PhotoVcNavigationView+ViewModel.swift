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
        var shareButtonVM: BasicButton.ViewModel?
        @Published
        var isHidden: Bool?
        
        init(
            photoCountLabelVM: BasicLabel.ViewModel? = nil,
            closeButtonVM: BasicButton.ViewModel? = nil,
            shareButtonVM: BasicButton.ViewModel? = nil,
            isHidden: Bool? = nil
        ) {
            self.photoCountLabelVM = photoCountLabelVM
            self.closeButtonVM = closeButtonVM
            self.shareButtonVM = shareButtonVM
            self.isHidden = isHidden
        }
        
        var text: String {
            get {photoCountLabelVM?.text ?? ""}
            set {photoCountLabelVM?.text = newValue
                print(newValue)
            }
        }
    }
}
