//
//  SuggestionView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit

extension SuggestionView {
    final class ViewModel: BasicViewModel {
        let labelVM: TappableLabel.ViewModel
        @Published var image: UIImage?
        
        
        init(
            labelVM: TappableLabel.ViewModel,
            image: UIImage?
        ) {
            self.labelVM = labelVM
            self.image = image
        }
    }
}
