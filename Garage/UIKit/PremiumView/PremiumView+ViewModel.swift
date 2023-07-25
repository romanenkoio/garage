//
//  PremiumView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 25.07.23.
//

import Foundation

extension PremiumView {
    final class ViewModel: BasicViewModel {
        let subTextLabelVM = BasicLabel.ViewModel(
            .text("Больше свободы, безлимитное создание документов и многое другое!")
        )
        
        let mainLabelVM = BasicLabel.ViewModel(
            .text("GarageGo Premium")
        )
    }
}
