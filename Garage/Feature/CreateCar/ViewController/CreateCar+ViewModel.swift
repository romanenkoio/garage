//
//  CreateCar+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

extension CreateCarViewController {
    final class ViewModel: BasicViewModel {
        
        private let errorVM = ErrorView.ViewModel(error: "Обязательное поле")
        
        var brandFieldVM: BasicInputView.ViewModel
        var modelFieldVM: BasicInputView.ViewModel
        var generationFieldVM: BasicInputView.ViewModel
        var winFieldVM: BasicInputView.ViewModel
        var yearFieldVM: BasicInputView.ViewModel
        var mileageFieldVM: BasicInputView.ViewModel
        
        let saveButtonVM = BasicButton.ViewModel(
            title: "Сохранить",
            isEnabled: false,
            style: .primary
        )
        
        override init() {
            brandFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Производитель")
            )
            
            modelFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Модель")
            )
            
            generationFieldVM = .init(
                errorVM: .init(),
                inputVM: .init(placeholder: "Поколение")
            )
            
            winFieldVM = .init(
                errorVM: .init(),
                inputVM: .init(placeholder: "WIN")
            )
            
            yearFieldVM = .init(
                errorVM: .init(),
                inputVM: .init(placeholder: "Год выпуска")
            )
            
            mileageFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Пробег")
            )
            
            super.init()
            initValidator()
        }
        
        private func initValidator() {
            validator.setForm([
                brandFieldVM.inputVM,
                modelFieldVM.inputVM,
                mileageFieldVM.inputVM
            ])
            
            brandFieldVM.rules = [.noneEmpty]
            modelFieldVM.rules = [.noneEmpty]
            mileageFieldVM.rules = [.noneEmpty]
            
            validator.formIsValid
                .sink { [weak self] value in
                    self?.saveButtonVM.isEnabled = value
                }
                .store(in: &cancellables)
        }
        
        private func initFields() {
            brandFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Производитель")
            )
            
            modelFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Производитель")
            )
            
            generationFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Поколение")
            )
            
            winFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "WIN")
            )
            
            yearFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Год выпуска")
            )
            
            mileageFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Пробег")
            )
        }
    }
}
