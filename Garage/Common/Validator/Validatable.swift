//
//  Validatable.swift
//  Logogo
//
//  Created by Illia Romanenko on 25.05.23.
//

import Foundation
import Combine

protocol Validatable {
    var rules: [ValidationRule] { get set }
    var isValid: Bool { get set }
    var isValidSubject: PassthroughSubject<Bool, Never> { get set }

    func validate() -> Bool
}

extension Validatable {
    func validate(_ data: String, with rule: ValidationRule) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", rule.pattern)
          return predicate.evaluate(with: data)
    }
}
