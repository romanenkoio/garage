//
//  TextField+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 17.05.23.
//

import Combine

extension BasicTextField {
    final class ViewModel: BasicViewModel, Validatable {
        
        var isValid: Bool = false
        var isValidSubject: PassthroughSubject<Bool, Never> = .init()
        var rules: [ValidationRule] = []
        
        @Published var text: String
        @Published var placeholder: String?
        @Published var isEnabled: Bool
        @Published var isSecure: Bool
        
        init(
            text: String = .empty,
            placeholder: String? = nil,
            isEnabled: Bool = true,
            isSecure: Bool = false
        ) {
            self.text = text
            self.placeholder = placeholder
            self.isEnabled = isEnabled
            self.isSecure = false
        }
        
        @discardableResult
        func validate() -> Bool {
            guard !rules.isEmpty else {
                isValid = true
                isValidSubject.send(true)
                return true
            }

            let result = rules.allSatisfy({ validate(text, with: $0) })
            isValid = result
            isValidSubject.send(result)

            return result
        }
    }
}
