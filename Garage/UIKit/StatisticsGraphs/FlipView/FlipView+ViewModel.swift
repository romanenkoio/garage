//
//  FlipView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 30.07.23.
//

import UIKit

extension FlipView {
    class ViewModel: BasicViewModel {
        let buttonVM: NavBarButton.ViewModel
        
        var showingBack = true
        
        override init() {
            self.buttonVM = .init(image: UIImage(systemName: "repeat"))
            super.init()
        }
    }
}
