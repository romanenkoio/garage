//
//  FBView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 7.07.23.
//

import Foundation

extension FloatingButtonView {
    class ViewModel: BasicViewModel {
        @Published
        var isMenuOnScreen: Bool = true
        @Published
        var actions: [TappableLabel.ViewModel] = []
        
        init(actions: [TappableLabel.ViewModel] = []) {
            self.actions = actions
        }
        
        func dismissButtons() {
            isMenuOnScreen.toggle()
        }
    }
}
