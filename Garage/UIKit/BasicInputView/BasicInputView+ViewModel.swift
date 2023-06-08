//
//  BasicInputView+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 18.05.23.
//

import Foundation

extension BasicInputView {
    final class ViewModel: BasicViewModel {
        var errorVM: ErrorView.ViewModel
        let inputVM: BasicTextField.ViewModel
        var actionImageVM: ActionImage.ViewModel?
        
        init(
            errorVM: ErrorView.ViewModel,
            inputVM: BasicTextField.ViewModel,
            actionImageVM: ActionImage.ViewModel? = nil
        ) {
            self.errorVM = errorVM
            self.inputVM = inputVM
            self.actionImageVM = actionImageVM
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
