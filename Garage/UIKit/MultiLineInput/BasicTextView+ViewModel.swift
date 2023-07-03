//
//  BasicTextView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 23.06.23.
//

import Foundation
import Combine

extension BasicTextView {
    final class ViewModel: BasicViewModel, Validatable, HasChangable {
        @Published var text: String
        
        var hasChange: Bool = false
        var hasChangeSubject: CurrentValueSubject<Bool, Never> = .init(false)
        var checkedValue: String?
        
        var isValid: Bool = false
        var isValidSubject: PassthroughSubject<Bool, Never> = .init()
        var rules: [ValidationRule] = []

        init(text: String = .empty) {
            self.text = text
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
