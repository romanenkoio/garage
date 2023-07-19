//
//  FormValidator.swift
//  Logogo
//
//  Created by Illia Romanenko on 25.05.23.
//

import Combine

class FormValidator {
    var cancellables: Set<AnyCancellable> = .init()
    var formIsValid: PassthroughSubject<Bool, Never> = .init()
    var isValid: Bool = false
    
    var validatedData: [Validatable] = []
    
    func setForm(_ data: [Validatable]) {
        self.validatedData = data
        self.sinkAll()
    }
    
    private func sinkAll() {
        cancellables.removeAll()
        
        validatedData.forEach { input in
            input.isValidSubject
                .sink { [weak self] _ in
                    self?.validateAll()
                }
                .store(in: &cancellables)
        }
    }
    
    private func validateAll() {
        let result = validatedData.allSatisfy( { $0.isValid } )
        formIsValid.send(result)
        isValid = result
    }
}
