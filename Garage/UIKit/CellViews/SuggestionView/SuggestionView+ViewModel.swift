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
        @Published var isSelected: Bool = false
        
        init(
            labelVM: TappableLabel.ViewModel,
            image: UIImage? = nil
        ) {
            self.labelVM = labelVM
            self.image = image
        }
    }
}
