//
//  SelectPlanView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//

import Foundation

extension SelectPlanView {
    final class ViewModel: BasicViewModel {
        let periodLabelVM = BasicLabel.ViewModel(.text("Месяц"))
        let priceLabelVM = BasicLabel.ViewModel(.text("Год"))
        let cancelLabelVM = BasicLabel.ViewModel(.text("Навсегда"))
    }
}
