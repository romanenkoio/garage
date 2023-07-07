//
//  CreateReminder+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 7.07.23.
//  
//

import UIKit

extension CreateReminderViewController {
    final class ViewModel: BasicControllerModel {
        let dateInputVM = BasicDatePicker.ViewModel(placeholder: Date().toString(.ddMMyy))
        let saveButtonVM = AlignedButton.ViewModel(buttonVM: .init(title: "Сохранить напоминание"))
        let commenntInputVM: MultiLineInput.ViewModel

        let shortTypeVM = SuggestionInput<ServiceType>.GenericViewModel(
            ServiceType.allCases,
            items: { items in
                return items.map({ ($0.title, nil) })
            },
            errorVM: .init(error: "Не может быть пустым"),
            inputVM: .init(placeholder: "Замена свечей"),
            isRequired: true
        )
        
        let mode: EntityStatus<Reminder>
        unowned var car: Car

        init(
            car: Car,
            mode: EntityStatus<Reminder>
        ) {
            self.car = car
            self.mode = mode
            
            shortTypeVM.descriptionLabelVM.text = "Краткое описание"
            let errorVM = ErrorView.ViewModel(error: "Проверьте данные")
            dateInputVM.minimumDate = Date().append(.day, value: 1)
            commenntInputVM = .init(
                inputVM: .init(),
                errorVM: errorVM,
                descriptionLabelVM: .init(text: "Комментарий")
            )
            
            super.init()
            initMode()
            
            validator.formIsValid
                .sink { [weak self] value in
                    guard let self else { return }
                    self.saveButtonVM.buttonVM.isEnabled = value && (mode == .create ? true : self.changeChecker.hasChange)
                }
                .store(in: &cancellables)
            
            changeChecker.formHasChange
                .sink { [weak self] value in
                    guard let self else { return }
                    self.saveButtonVM.buttonVM.isEnabled = self.validator.isValid && !value
                    
                }
                .store(in: &cancellables)
        }
        
        func initMode() {
            initValidator()
            saveButtonVM.buttonVM.isEnabled = false

            switch mode {
            case .create:
                break
            case .edit(let object):
                shortTypeVM.inputVM.setText(object.short)
                commenntInputVM.inputVM.text = object.comment.wrapped
                dateInputVM.initDate(object.date)
                saveButtonVM.buttonVM.title = "Обновить"
                initChangeChecker()
            }
        }
        
        private func initValidator() {
            validator.setForm([
                shortTypeVM.inputVM,
                dateInputVM
            ])
            
            shortTypeVM.rules = [.noneEmpty]
            dateInputVM.rules = [.noneEmpty]
        }
        
        private func initChangeChecker() {
            changeChecker.setForm([
                shortTypeVM.inputVM,
                dateInputVM
            ])
        }
        
        func action() {
            switch mode {
            case .create:
                guard let date = dateInputVM.date else { return }
                let reminder = Reminder(
                    short: shortTypeVM.text,
                    comment: commenntInputVM.inputVM.text,
                    carID: car.id,
                    date: date
                )
                RealmManager().write(object: reminder)
                reminder.setPush()
            case .edit(let object):
                break
            }
        }
    }
}
