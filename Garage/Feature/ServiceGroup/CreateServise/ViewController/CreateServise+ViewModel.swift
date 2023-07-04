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
        let commenntInputVM: MultiLineInput.ViewModel
        
        var saveCompletion: Completion?
        var mode: EntityStatus<Service>

        init(mode: EntityStatus<Service>) {
            self.mode = mode
            
            let errorVM = ErrorView.ViewModel(error: "Обязательое поле")
            
            nameInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "МегаСварщик"),
                descriptionVM: .init(text: "Название")
            )
            
            phoneInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "+375257776655"),
                descriptionVM: .init(text: "Номер телефона")
            )
            
            specialisationInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Сварка"),
                descriptionVM: .init(text: "Специализация")
            )
            
            adressInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Макаёнка 43"),
                descriptionVM: .init(text: "Адрес")
            )
            
            commenntInputVM = .init(
                inputVM: .init(),
                errorVM: errorVM,
                descriptionLabelVM: .init(text: "Комментарий")
            )
            
            saveButtonVM = .init(
                buttonVM: .init(title: "Сохранить", isEnabled: false, style: .primary)
            )

            super.init()
            saveButtonVM.buttonVM.action = .touchUpInside { [weak self] in
                guard let self else { return }
                switch mode {
                case .create:
                    saveService()
                case .edit(let service):
                    update(service)
                }
                self.saveCompletion?()
            }
            initMode()
        }
        
        private func saveService() {
            let service = Service(
                phone: self.phoneInputVM.text,
                adress: self.adressInputVM.text,
                name: self.nameInputVM.text,
                specialisation: self.specialisationInputVM.text,
                comment: self.commenntInputVM.inputVM.text
            )
            RealmManager<Service>().write(object: service)
        }
        
        private func update(_ service: Service) {
            RealmManager<Service>().update { [weak self] realm in
                do {
                    try realm.write({ [weak self] in
                        guard let self else { return }
                        service.phone = self.phoneInputVM.text
                        service.adress = self.adressInputVM.text
                        service.name = self.nameInputVM.text
                        service.specialisation = self.specialisationInputVM.text
                        service.comment = self.commenntInputVM.inputVM.text
                    })
                } catch let error {
                    print(error)
                }
            }
        }
        
        private func initValidator() {
            validator.setForm([
                nameInputVM.inputVM,
                adressInputVM.inputVM
            ])
            
            nameInputVM.rules = [.noneEmpty]
            phoneInputVM.rules = [.noneEmpty]
            
            validator.formIsValid
                .removeDuplicates()
                .sink { [weak self] value in
                    self?.saveButtonVM.buttonVM.isEnabled = value
                }
                .store(in: &cancellables)
            
            changeChecker.formHasChange
                .removeDuplicates()
                .sink { [weak self] value in
                    guard let self else { return }
                    self.saveButtonVM.buttonVM.isEnabled = self.validator.isValid && !value
                    
                }
                .store(in: &cancellables)
        }
        
        func initMode() {
            initValidator()
            guard case let .edit(service) = mode else {
              return
            }
            
            self.phoneInputVM.text = service.phone
            self.adressInputVM.text = service.adress
            self.nameInputVM.text = service.name
            self.specialisationInputVM.text = service.specialisation
            self.commenntInputVM.inputVM.text = service.comment.wrapped
            
            changeChecker.setForm([
                phoneInputVM.inputVM,
                adressInputVM.inputVM,
                nameInputVM.inputVM,
                specialisationInputVM.inputVM,
                commenntInputVM.inputVM
            ])
        }
        
        func removeService(completion: Completion?) {
            guard case let .edit(service) = mode else {
              return
            }
            RealmManager().delete(object: service, completion: completion)
        }
        
    }
}
