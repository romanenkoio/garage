//
//  CreateRepair+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 10.06.23.
//  
//

import UIKit

extension CreateRepairViewController {
    final class ViewModel: BasicViewModel {
        var carFieldVM = BasicInputView.ViewModel(inputVM: .init(placeholder: "Автомобиль"))
        var serviseFieldVM = BasicInputView.ViewModel(inputVM: .init(placeholder: "Сервис"))
        var costFieldVM = BasicInputView.ViewModel(inputVM: .init(placeholder: "Стоимость"))
        var mileageFieldVM = BasicInputView.ViewModel(inputVM: .init(placeholder: "Пробег"))
        var datePickerVM = BasicDatePicker.ViewModel()
        var saveButtonVM = BasicButton.ViewModel()
        
        override init() {
            super.init()
        }
    }
}
