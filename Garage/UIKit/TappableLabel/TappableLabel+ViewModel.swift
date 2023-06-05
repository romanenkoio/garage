//
//  TappableLabel+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 22.05.23.
//

import Foundation

extension TappableLabel {
    final class ViewModel: BasicLabel.ViewModel {
        var action: Completion?
        
        init(
            text: String,
            action: Completion? = nil
        ) {
            self.action = action
            super.init(text: text)
        }
    }
}
