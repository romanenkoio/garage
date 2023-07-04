//
//  CreateRecord+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 15.06.23.
//  
//

import UIKit

extension CreateRecordViewController {
    final class ViewModel: BasicViewModel {
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
        }
        
        func saveRecord() {
            let record = Record(
                short: shortTypeVM.text,
                carID: car.id,
                serviceID: serivesListVM.selectedItem?.id,
                cost: costInputVM.text.toDouble(),
                mileage: mileageInputVM.text.toDouble(),
                date: dateInputVM.date ?? Date(),
                comment: commenntInputVM.inputVM.text
            )
            RealmManager<Record>().write(object: record)
            
            if mileageInputVM.text.toInt() > car.mileage {
                RealmManager().update { [weak self] realm in
                    guard let self else { return }
                    car.mileage = mileageInputVM.text.toInt()
                }
            }
        
            self.imagePickerVM.items.forEach { image in
                guard let data = image.jpegData(compressionQuality: 1) else { return }
                let photo = Photo(record, image: data)
                RealmManager<Photo>().write(object: photo)
            }
        }
    }
}
