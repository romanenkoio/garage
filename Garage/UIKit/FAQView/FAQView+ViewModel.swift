//
//  FAQView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 12.09.23.
//

import Foundation
import Combine

extension FAQView {
    final class ViewModel: BasicViewModel {
        let periodLabelVM = BasicLabel.ViewModel()
        let titleLabelVM = BasicLabel.ViewModel()
        
        init(_ point: FAQDisplayable) {
            self.periodLabelVM.textValue = .text(point.peroid)
            self.titleLabelVM.textValue = .text(point.title)
        }
    }
}
