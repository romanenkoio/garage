//
//  SelectPlanView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//

import Foundation
import Combine

extension SelectPlanView {
    final class ViewModel: BasicViewModel {
        @Published var isSelected = false
        var selectedSubject: PassthroughSubject<SelectPlanView.ViewModel, Never> = .init()
        
        let periodLabelVM = BasicLabel.ViewModel(.text("Месяц"))
        let priceLabelVM = BasicLabel.ViewModel(.text("3$/месяц"))
        let cancelLabelVM = BasicLabel.ViewModel(.text("Навсегда"))
        
        init(isSelected: Bool = false) {
            self.isSelected = isSelected
        }
    }
}
