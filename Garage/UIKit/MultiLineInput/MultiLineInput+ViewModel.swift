//
//  MultiLineInput+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 20.06.23.
//

import Foundation

extension MultiLineInput {
    final class ViewModel: BasicViewModel {
        var errorVM: ErrorView.ViewModel?
        let requiredLabelVM = BasicLabel.ViewModel(text: "*обязательное поле")
        let descriptionLabelVM: BasicLabel.ViewModel
        let inputVM: BasicTextView.ViewModel
        
        @Published
        var isRequired: Bool
        
        init(
            inputVM: BasicTextView.ViewModel = .init(),
            errorVM: ErrorView.ViewModel? = nil,
            descriptionLabelVM: BasicLabel.ViewModel = .init(),
            isRequired: Bool = false
        ) {
            self.errorVM = errorVM
            self.descriptionLabelVM = descriptionLabelVM
            self.isRequired = isRequired
            self.inputVM = inputVM
        }
    }
}
