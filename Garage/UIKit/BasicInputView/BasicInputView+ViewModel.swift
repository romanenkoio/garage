//
//  BasicInputView+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 18.05.23.
//

import Foundation

extension BasicInputView {
    class ViewModel: BasicViewModel {
        var errorVM: ErrorView.ViewModel?
        let inputVM: BasicTextField.ViewModel
        var actionImageVM: ActionImage.ViewModel?
        let requiredLabelVM = BasicLabel.ViewModel(text: "*обязательное поле")
        let descriptionLabelVM: BasicLabel.ViewModel
        
        @Published
        var isRequired: Bool
        
        init(
            errorVM: ErrorView.ViewModel? = nil,
            inputVM: BasicTextField.ViewModel,
            descriptionVM: BasicLabel.ViewModel = .init(),
            actionImageVM: ActionImage.ViewModel? = nil,
            isRequired: Bool = false
        ) {
            self.errorVM = errorVM
            self.inputVM = inputVM
            self.actionImageVM = actionImageVM
            self.isRequired = isRequired
            self.descriptionLabelVM = descriptionVM
        }
        
        var placeholder: String {
            get { inputVM.placeholder.wrapped }
            set { inputVM.placeholder = newValue}
        }

        var text: String {
            get { inputVM.text }
            set {
                inputVM.text = newValue
                inputVM.validate()
            }
        }
        
        var rules: [ValidationRule] {
            get { return inputVM.rules }
            set { inputVM.rules = newValue}
        }
    }
}
