//
//  CreateFuelRecord+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 26.09.23.
//  
//

import UIKit

extension CreateFuelRecordViewController {
    final class ViewModel: BasicControllerModel {
        unowned var car: Car
        
        let dateInputVM = BasicDatePicker.ViewModel(date: Date.now)
        let costInputVM: BasicInputView.ViewModel
        let quantityInputVM: BasicInputView.ViewModel
        let saveButtonVM = AlignedButton.ViewModel(buttonVM: .init(title: "Сохранить запись"))
        let mode: EntityStatus<FuelRecord>
        
        init(
            car: Car,
            mode: EntityStatus<FuelRecord>
        ) {
            self.car = car
            self.mode = mode
            let errorVM = ErrorView.ViewModel(error: "Не может быть пустым")
            costInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "50"),
                descriptionVM: .init(.text("Стоимость"))
            )
            
            quantityInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "34"),
                descriptionVM: .init(.text("Количество топлива"))
            )
            super.init()
            initMode()
        }
        
        func initMode() {
            initValidator()
            
            switch mode {
                case .create:
                    saveButtonVM.buttonVM.isEnabled = false
                    dateInputVM.setNewDate(Date())
                    dateInputVM.descriptionLabel = "Дата заправки"
                case .edit(let object):
                    dateInputVM.initDate(object.date)
                    dateInputVM.descriptionLabel = "Изменить дату"
                    costInputVM.text = "\(object.cost ?? .zero)"
                    quantityInputVM.text = "\(object.quantity ?? .zero)"
                    initChangeChecker()
                default: break
            }
        }
        
        private func initValidator() {
            validator.setForm([
                dateInputVM,
                costInputVM.inputVM,
                quantityInputVM.inputVM
            ])
            
            dateInputVM.rules = [.noneEmpty]
            quantityInputVM.rules = [.noneEmpty]
            costInputVM.rules = [.noneEmpty]
            
            validator.formIsValid
                .sink { [weak self] value in
                    guard let self else { return }
                    switch self.mode {
                        case .create:
                            self.saveButtonVM.buttonVM.isEnabled = value
                        case .edit:
                            self.saveButtonVM.buttonVM.isEnabled = value && self.changeChecker.hasChange
                        default: break
                    }
                }
                .store(in: &cancellables)
            
            changeChecker.formHasChange
                .sink { [weak self] value in
                    guard let self else { return }
                    self.saveButtonVM.buttonVM.isEnabled = self.validator.isValid && value
                    
                }
                .store(in: &cancellables)
        }
        
        private func initChangeChecker() {
            changeChecker.setForm([
                dateInputVM,
                costInputVM.inputVM,
                quantityInputVM.inputVM
            ])
        }
        
        func action() {
            switch mode {
                case .create:
                    saveFuelRecord()
                case .edit(let object):
                    updateFuelRecord(object)
                default: break
            }
        }
        
        private func saveFuelRecord() {
            let fuelRecord = FuelRecord(
                short: "Заправка",
                carID: car.id,
                cost: costInputVM.text.toInt(),
                date: dateInputVM.date ?? Date(),
                quantity: quantityInputVM.text.toInt()
            )
            RealmManager<FuelRecord>().write(object: fuelRecord)
        }
        
        private func updateFuelRecord(_ record: FuelRecord) {
            RealmManager().update { [weak self] realm in
                guard let self else { return }
                
                try? realm.write({
                    record.short = "Заправка"
                    record.cost = self.costInputVM.text.toInt()
                    record.quantity = self.quantityInputVM.text.toInt()
                    record.date = self.dateInputVM.date ?? Date()
                })
            }
        }
        
        func removeRecord(completion: Completion?) {
            guard case let .edit(record) = mode else {
              return
            }
            RealmManager().delete(object: record, completion: completion)
        }
    }
}
