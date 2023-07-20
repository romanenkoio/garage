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
        
        func setObservedText(_ text: String) {
            self.text = text
            self.checkedValue = text
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
        
        func checkChanged(_ value: String) {
            guard let checkedValue else {
                self.hasChange = false
                self.hasChangeSubject.send(false)
                return
            }
            
            self.hasChange = checkedValue != value
            self.hasChangeSubject.send(checkedValue != value)
        }
    }
}
