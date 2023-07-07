//
//  CreateRecord+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 15.06.23.
//  
//

import UIKit

extension CreateRecordViewController {
    final class ViewModel: BasicControllerModel {
        unowned var car: Car
        
        
        @Published
        private(set) var services = [Service]()
        private var selectedService: Service?
        
        let dateInputVM = BasicDatePicker.ViewModel(placeholder: Date().toString(.ddMMyy))
        let costInputVM: BasicInputView.ViewModel
        let mileageInputVM: BasicInputView.ViewModel
        let imagePickerVM = BasicImageListView.ViewModel(descriptionLabelVM: .init(text: "Добавить фото"))
        let saveButtonVM = AlignedButton.ViewModel(buttonVM: .init(title: "Сохранить запись"))
        
        let shortTypeVM = SuggestionInput<ServiceType>.GenericViewModel(
            ServiceType.allCases,
            items: { items in
                return items.map({ ($0.title, nil) })
            },
            errorVM: .init(error: "Не может быть пустым"),
            inputVM: .init(placeholder: "Замена свечей"),
            isRequired: true
        )
        let commenntInputVM: MultiLineInput.ViewModel
        
        let serivesListVM = BasicList<Service>.GenericViewModel<Service>(
            title: "Выберите сервис",
            RealmManager<Service>().read(),
            placeholder: "Название сервиса") { items in
                return items.map({ $0.name })
            }
        let mode: EntityStatus<Record>
        
        init(
            car: Car,
            mode: EntityStatus<Record>
        ) {
            self.car = car
            self.mode = mode
            services = RealmManager<Service>().read()

            shortTypeVM.descriptionLabelVM.text = "Краткое описание"
            let errorVM = ErrorView.ViewModel(error: "Проверьте данные")
            
            costInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "120 BYN"),
                descriptionVM: .init(text: "Стоимость")
            )
            
            commenntInputVM = .init(
                inputVM: .init(),
                errorVM: errorVM,
                descriptionLabelVM: .init(text: "Комментарий")
            )

            mileageInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "\(car.mileage + 1000) км"),
                descriptionVM: .init(text: "Текущий пробег"),
                isRequired: true
            )
            
            imagePickerVM.description = "Добавить фото"
            imagePickerVM.editingEnabled = true
            
            super.init()
            initMode()
        }
        
        func initMode() {
            initValidator()
            
            switch mode {
            case .create:
                saveButtonVM.buttonVM.isEnabled = false
            case .edit(let object):
                dateInputVM.initDate(object.date)
                costInputVM.text = "\(object.cost ?? .zero)"
                mileageInputVM.text = "\(object.mileage)"
                shortTypeVM.inputVM.setText(object.short)
                imagePickerVM.items = RealmManager<Photo>().read().filter({ $0.recordId == object.id }).compactMap({ $0.converted })
                saveButtonVM.buttonVM.title = "Обновить"
                initChangeChecker()
            }
        }
        
        private func initValidator() {
            validator.setForm([
                dateInputVM,
                costInputVM.inputVM,
                shortTypeVM.inputVM,
                mileageInputVM.inputVM
            ])
            
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
        
        private func initChangeChecker() {
            changeChecker.setForm([
                dateInputVM,
                costInputVM.inputVM,
                shortTypeVM.inputVM,
                imagePickerVM
            ])
        }
        
        func action() {
            switch mode {
            case .create:
                saveRecord()
            case .edit(let object):
                updateRecord(object)
            }
        }
        
        private func saveRecord() {
            let record = Record(
                short: shortTypeVM.text,
                carID: car.id,
                serviceID: serivesListVM.selectedItem?.id,
                cost: costInputVM.text.toInt(),
                mileage: mileageInputVM.text.toInt(),
                date: dateInputVM.date ?? Date(),
                comment: commenntInputVM.inputVM.text
            )
            RealmManager<Record>().write(object: record)
            
            updateMilageIfNeeded()
            savePhoto(for: record, shouldRemove: false)
        }
        
        private func updateRecord(_ record: Record) {
            RealmManager().update { [weak self] realm in
                guard let self else { return }

                try? realm.write({ [weak self] in
                    guard let self else { return }
                    record.short = shortTypeVM.text
                    record.serviceID = serivesListVM.selectedItem?.id
                    record.cost = costInputVM.text.toInt()
                    record.mileage = mileageInputVM.text.toInt()
                    record.date = dateInputVM.date ?? Date()
                    record.comment = commenntInputVM.inputVM.text
                })
                
                savePhoto(for: record, shouldRemove: true)
                updateMilageIfNeeded()
            }
        }
        
        private func savePhoto(for record: Record, shouldRemove: Bool) {
            if shouldRemove {
                RealmManager<Photo>()
                    .read()
                    .filter({ $0.recordId == record.id })
                    .forEach({ RealmManager().delete(object: $0)})
            }
            
            self.imagePickerVM.items.forEach { image in
                guard let data = image.jpegData(compressionQuality: 1) else { return }
                let photo = Photo(record, image: data)
                RealmManager<Photo>().write(object: photo)
            }
        }
        
        private func updateMilageIfNeeded() {
            if mileageInputVM.text.toInt() > car.mileage {
                RealmManager().update { [weak self] realm in
                    try? realm.write { [weak self] in
                        guard let self else { return }
                        car.mileage = mileageInputVM.text.toInt()
                    }
                }
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
