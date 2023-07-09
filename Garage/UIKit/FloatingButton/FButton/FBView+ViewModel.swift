//
//  FBView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 7.07.23.
//

import UIKit

extension FloatingButtonView {
    class ViewModel: BasicViewModel {
        @Published
        var isMenuOnScreen: Bool = true
        @Published
        var actions: [FloatingButtonSecondItem.ViewModel] = []
        
        var mainButtonAction: Completion?
        
        init(
            actions: [FloatingButtonSecondItem.ViewModel] = [],
            mainButtonAction: Completion? = nil
        ) {
            self.actions = actions
            self.mainButtonAction = mainButtonAction
        }
        
        func dismissButtons() {
            isMenuOnScreen.toggle()
        }
    }
}
