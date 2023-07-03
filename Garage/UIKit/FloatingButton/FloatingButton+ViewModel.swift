//
//  FloatingButton+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 22.06.23.
//

import Foundation

extension FloatingButton {
    final class ViewModel {
        @Published var isOpen = false
        @Published var actions: [TappableLabel.ViewModel] = []
        
        init(actions: [TappableLabel.ViewModel] = []) {
            self.actions = actions
        }
    }
}
