//
//  SuggestionView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

extension SuggestionView {
    final class ViewModel: BasicViewModel {
        let labelVM: TappableLabel.ViewModel
        
        init(labelVM: TappableLabel.ViewModel) {
            self.labelVM = labelVM
        }
    }
}
