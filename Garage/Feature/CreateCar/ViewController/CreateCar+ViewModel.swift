//
//  CreateCar+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

extension CreateCarViewController {
    final class ViewModel: BasicControllerModel {
        private let errorVM = ErrorView.ViewModel(error: "Обязательное поле")
        
        var brandFieldVM: BasicInputView.ViewModel
        var modelFieldVM: BasicInputView.ViewModel
        var generationFieldVM: BasicInputView.ViewModel
        var winFieldVM: BasicInputView.ViewModel
        var yearFieldVM: BasicInputView.ViewModel
        var mileageFieldVM: BasicInputView.ViewModel
        
        var succesCreateCompletion: Completion?
        var suggestionCompletion: SelectArrayCompletion?
        
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
            initSuggestionAction()
            
            saveButtonVM.action = .touchUpInside { [weak self] in
                guard let self else { return }
                let car = Car(
                    brand: self.brandFieldVM.text,
                    model: self.modelFieldVM.text,
                    generation: self.generationFieldVM.text,
                    year: self.yearFieldVM.text.toInt(),
                    win: self.winFieldVM.text,
                    mileage: self.mileageFieldVM.text.toInt() ?? .zero
                )
                RealmManager<Car>().write(object: car)
                self.succesCreateCompletion?()
            }
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
        
        private func initSuggestionAction() {
            brandFieldVM.actionImageVM = .init(
                action: { [weak self] in
                    guard let self else { return }
                    Task { @MainActor in
                        do {
                            let result = try await NetworkManager
                                .sh
                                .request(GarageApi.brands, model: Wrapper<Brand>.self).result
                            self.suggestionCompletion?(result)
                        } catch let error {
                            print(error)
                        }
                    }
                }, image: UIImage(systemName: "list.dash"),
                isEnable: true
            )
            
            modelFieldVM.actionImageVM = .init(
                action: { [weak self] in
                    guard let self else { return }
                    Task { @MainActor in
                        do {
                            let result = try await NetworkManager
                                .sh
                                .request(GarageApi.models(brand: self.brandFieldVM.text), model: Wrapper<Model>.self).result
                            self.suggestionCompletion?(result)
                        } catch let error {
                            print(error)
                        }
                    }
                   
                }, image: UIImage(systemName: "list.dash"),
                isEnable: false
            )
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
