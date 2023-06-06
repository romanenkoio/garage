//
//  CreateServise+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//  
//

import UIKit

extension CreateServiseViewController {
    final class ViewModel: BasicViewModel {
        let nameInputVM: BasicInputView.ViewModel
        let phoneInputVM: BasicInputView.ViewModel
        let specialisationInputVM: BasicInputView.ViewModel
        let adressInputVM: BasicInputView.ViewModel
        let saveButtonVM: BasicButton.ViewModel
        
        var saveCompletion: Completion?
        
        override init() {
            let errorVM = ErrorView.ViewModel(error: "Обязательое поле")
            
            nameInputVM = .init(errorVM: errorVM, inputVM: .init(placeholder: "Название"))
            phoneInputVM = .init(errorVM: errorVM, inputVM: .init(placeholder: "Телефон"))
            specialisationInputVM = .init(errorVM: errorVM, inputVM: .init(placeholder: "Специализация"))
            adressInputVM = .init(errorVM: errorVM, inputVM: .init(placeholder: "Адрес"))
            
            saveButtonVM = .init(title: "Сохранить", isEnabled: false, style: .primary)

            super.init()
            saveButtonVM.action = .touchUpInside { [weak self] in
                guard let self else { return }
                let service = Service(
                    phone: self.phoneInputVM.text,
                    adress: self.adressInputVM.text,
                    name: self.nameInputVM.text,
                    specialisation: self.specialisationInputVM.text
                )
                RealmManager<Service>().write(object: service)
                self.saveCompletion?()
            }
            initValidator()
        }
        
        private func initValidator() {
            validator.setForm([
                nameInputVM.inputVM,
                adressInputVM.inputVM
            ])
            
            nameInputVM.rules = [.noneEmpty]
            adressInputVM.rules = [.noneEmpty]
            
            validator.formIsValid
                .sink { [weak self] value in
                    self?.saveButtonVM.isEnabled = value
                }
                .store(in: &cancellables)
        }
        
    }
}
