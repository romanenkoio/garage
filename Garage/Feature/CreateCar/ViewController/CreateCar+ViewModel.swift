//
//  CreateCar+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import Foundation

extension CreateCarViewController {
    final class ViewModel: BasicControllerModel {
        private let errorVM = ErrorView.ViewModel(error: "Обязательное поле")
        private let vinErrorVM = ErrorView.ViewModel(error: "Проверьте VIN")
        
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
        var logoImage: UIImage?
        
        override init() {
            brandFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Toyota"),
                descriptionVM: .init(text: "Производитель"),
                isRequired: true
            )
            
            modelFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "RAV4"),
                descriptionVM: .init(text: "Модель"),
                isRequired: true
            )
            
            generationFieldVM = .init(
                errorVM: .init(),
                inputVM: .init(placeholder: "Поколение")
            )
            
            winFieldVM = .init(
                errorVM: vinErrorVM,
                inputVM: .init(placeholder: "JTEHH20V906089188"),
                descriptionVM: .init(text: "VIN номер")
            )
            
            yearFieldVM = .init(
                errorVM: .init(),
                inputVM: .init(placeholder: "2003"),
                descriptionVM: .init(text: "Год выпуска")
            )
            
            mileageFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "308000"),
                descriptionVM: .init(text: "Пробег"),
                isRequired: true
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
                    mileage: self.mileageFieldVM.text.toInt() ?? .zero,
                    logo: self.logoImage?.pngData()
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
            winFieldVM.rules = [.vin]
            
            validator.formIsValid
                .sink { [weak self] value in
                    self?.saveButtonVM.isEnabled = value
                }
                .store(in: &cancellables)
            
            winFieldVM.inputVM.isValidSubject.sink { [weak self] value in
                self?.winFieldVM.actionImageVM?.isEnabled = value
                self?.decodeVIN()
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
                                .request(
                                    GarageApi.brands,
                                    model: Wrapper<Brand>.self
                                ).result
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
                                .request(
                                    GarageApi.models(brand: self.brandFieldVM.text),
                                    model: Wrapper<Model>.self
                                ).result
                            self.suggestionCompletion?(result)
                        } catch let error {
                            print(error)
                        }
                    }
                   
                }, image: UIImage(systemName: "list.dash"),
                isEnable: false
            )
            
            winFieldVM.actionImageVM = .init(
                action: { [weak self] in
                    guard let self else { return }
                    self.decodeVIN()
                   
                }, image: UIImage(systemName: "magnifyingglass"),
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
        
        func decodeVIN() {
            Task { @MainActor in
                do {
                    self.isLoadind.send(true)
                    guard !self.winFieldVM.text.isEmpty else { return }
                    let result = try await NetworkManager
                        .sh
                        .request(
                            GarageApi.decodeWIN(win: self.winFieldVM.text),
                            model: Wrapper<VINDeocdedValue>.self
                        ).result
                    parseDecodedWin(values: result)
                    self.isLoadind.send(false)
                } catch let error {
                    print(error)
                    self.isLoadind.send(false)
                }
            }
        }
        
        func getLogoBy(_ brand: String) async throws {
            Task { @MainActor in
                do {
                    guard let url = URL(string: "https://pictures.shoop-vooop.cloudns.nz/cars-logos/api/images/\(brand.lowercased())_resized.png") else { return }
                    let request = URLRequest(url: url)
                    let (data, _) = try await URLSession.shared.data(for: request)
                    if let image = UIImage(data: data) {
                        self.logoImage = image
                    }
                } catch let error {
                    print(error)
                }
            }
        }
        
        func parseDecodedWin(values: [VINDeocdedValue]) {
            let clearValues = values.filter({ !$0.value.wrapped.isEmpty && $0.value.wrapped != "Not Applicable"})
            VINDecodedType.allCases.forEach { type in
                guard let data = clearValues.filter({ $0.type == type.rawValue }).first else { return }
                switch type {
                case .model:
                    modelFieldVM.text = data.value.wrapped
                case .make:
                    brandFieldVM.text = data.value.wrapped
                    Task { @MainActor in
                        try? await getLogoBy(data.value.wrapped)
                    }
                    modelFieldVM.actionImageVM?.isEnabled = true
                case .year:
                    yearFieldVM.text = data.value.wrapped
                }
            }
        }
    }
}
