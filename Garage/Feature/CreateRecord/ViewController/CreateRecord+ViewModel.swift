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
        
        let dateInputVM = BasicDatePicker.ViewModel(placeholder: Date().formatData(formatType: .ddMMyy))
        let costInputVM: BasicInputView.ViewModel
        let mileageInputVM: BasicInputView.ViewModel
        let imagePickerVM = BasicImageListView.ViewModel()
        let saveButtonVM = AlignedButton.ViewModel(buttonVM: .init(title: "Сохранить запись"))
        let serivesListVM = BasicList<Service>.GenericViewModel<Service>(
            title: "Выберите сервис",
            RealmManager<Service>().read(),
            placeholder: "Название сервиса") { items in
                return items.map({ $0.name })
            }
        
        init(car: Car) {
            self.car = car
            
            let errorVM = ErrorView.ViewModel(error: "Проверьте данные")
            
            costInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "120 BYN"),
                descriptionVM: .init(text: "Стоимость")
            )
            
            mileageInputVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "\(car.mileage + 1000) км"),
                descriptionVM: .init(text: "Текущий пробег"),
                isRequired: true
            )
        }
        
        func saveRecord() {
            
        }
    }
}
