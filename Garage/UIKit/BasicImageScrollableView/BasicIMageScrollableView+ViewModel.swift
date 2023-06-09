//
//  BasicIMageScrollableView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.06.23.
//

import Foundation

extension BasicImageScrollableView {
    class ViewModel: BasicViewModel {
        let buttonVM = BasicButton.ViewModel()
        
        override init() {
            buttonVM.style = .primary
            buttonVM.title = "Test"
            super.init()
            
        }
    }
}
