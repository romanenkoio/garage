//
//  BasicInputView+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 18.05.23.
//

import Foundation

extension BasicInputView {
    final class ViewModel: BasicViewModel {
        var errorVM = ErrorView.ViewModel()
        let inputVM = BasicTextField.ViewModel()
        
        @Published var validationMode: ValidationMode = .none
        
        var placeholder: String {
            get { inputVM.placeholder.wrapped }
            set { inputVM.placeholder = newValue}
        }

        var text: String {
            get { inputVM.text }
            set { inputVM.text = newValue}
        }
        
        var rules: [ValidationRule] {
            get { return inputVM.rules }
            set { inputVM.rules = newValue}
        }
    }
}
