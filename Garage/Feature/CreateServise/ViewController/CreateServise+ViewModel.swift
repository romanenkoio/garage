//
//  CreateServise+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//  
//

import UIKit

extension CreateServiseViewController {
    final class ViewModel: BasicControllerModel {
        let nameInputVM: BasicInputView.ViewModel
        let phoneInputVM: BasicInputView.ViewModel
        let specialisationInputVM: BasicInputView.ViewModel
        let adressInputVM: BasicInputView.ViewModel
        let saveButtonVM: AlignedButton.ViewModel
        
        var saveCompletion: Completion?
        
        override init() {
            let errorVM = ErrorView.ViewModel(error: "Обязательое поле")
            
            nameInputVM = .init(errorVM: errorVM, inputVM: .init(placeholder: "МегаСварщик"), descriptionVM: .init(text: "Название"))
            phoneInputVM = .init(errorVM: errorVM, inputVM: .init(placeholder: "+375257776655"), descriptionVM: .init(text: "Номер телефона"))
            specialisationInputVM = .init(errorVM: errorVM, inputVM: .init(placeholder: "Сварка"), descriptionVM: .init(text: "Специализация"))
            adressInputVM = .init(errorVM: errorVM, inputVM: .init(placeholder: "Макаёнка 43"), descriptionVM: .init(text: "Адрес"))
            
            saveButtonVM = .init(
                buttonVM: .init(title: "Сохранить", isEnabled: false, style: .primary)
            )

            super.init()
            saveButtonVM.buttonVM.action = .touchUpInside { [weak self] in
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
            phoneInputVM.rules = [.noneEmpty]
            
            validator.formIsValid
                .sink { [weak self] value in
                    self?.saveButtonVM.buttonVM.isEnabled = value
                }
                .store(in: &cancellables)
        }
        
    }
}
