//
//  AlignedButton+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 13.06.23.
//

import Foundation

extension AlignedButton {
    final class ViewModel: BasicViewModel {
        let buttonVM: BasicButton.ViewModel
        
        init(buttonVM: BasicButton.ViewModel) {
            self.buttonVM = buttonVM
        }
    }
}
