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
        var winFieldVM: BasicInputView.ViewModel
        var yearFieldVM: BasicInputView.ViewModel
        var mileageFieldVM: BasicInputView.ViewModel
        let imageListVM = BasicImageListView.ViewModel()
        
        var succesCreateCompletion: Completion?
        var suggestionCompletion: SelectArrayCompletion?
        
        let saveButtonVM = AlignedButton.ViewModel(buttonVM: .init(
            title: "Сохранить",
            isEnabled: false,
            style: .primary
        ))
        
        var logoImage: UIImage?
        var mode: EntityStatus<Car>
        
        init(mode: EntityStatus<Car>) {
            self.mode = mode

            brandFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "Toyota"),
                descriptionVM: .init(.text("Производитель")),
                isRequired: true
            )
            
            modelFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "RAV4"),
                descriptionVM: .init(.text("Модель")),
                isRequired: true
            )
            
            winFieldVM = .init(
                errorVM: vinErrorVM,
                inputVM: .init(placeholder: "JTEHH20V906089188"),
                descriptionVM: .init(.text("VIN номер"))
            )
            
            yearFieldVM = .init(
                errorVM: .init(),
                inputVM: .init(placeholder: "2003"),
                descriptionVM: .init(.text("Год выпуска"))
            )
            
            mileageFieldVM = .init(
                errorVM: errorVM,
                inputVM: .init(placeholder: "308000"),
                descriptionVM: .init(.text("Пробег")),
                isRequired: true
            )
            
            super.init()
            initMode()
            initSuggestionAction()
            
            imageListVM.editingEnabled = true
            imageListVM.description = "Добавить фото"

            brandFieldVM.inputVM.$text.sink { [weak self] value in
                self?.getLogoBy(value)
            }
            .store(in: &cancellables)
            
            saveButtonVM.buttonVM.action = .touchUpInside { [weak self] in
                guard let self else { return }
                switch mode {
                case .createFrom:
                    break
                case .create:
                    saveCar()
                case .edit(let object):
                    update(object)
                }
              
            }
        }
        
        private func saveCar() {
            let car = Car(
                brand: self.brandFieldVM.text,
                model: self.modelFieldVM.text,
                year: self.yearFieldVM.text.toInt(),
                win: self.winFieldVM.text,
                mileage: self.mileageFieldVM.text.toInt(),
                logo: self.logoImage?.pngData()
            )
            RealmManager<Car>().write(object: car)
            
           savePhoto(for: car, shouldRemove: false)
            
            self.succesCreateCompletion?()
        }
        
        private func update(_ car: Car) {
            RealmManager<Car>().update { [weak self] realm in
                do {
                    try realm.write { [weak self] in
                        guard let self else { return }
                        car.brand = brandFieldVM.text
                        car.model = modelFieldVM.text
                        car.year = yearFieldVM.text.toInt()
                        car.win = winFieldVM.text
                        car.mileage = mileageFieldVM.text.toInt()
                    }
                    self?.savePhoto(for: car, shouldRemove: true)
                    self?.succesCreateCompletion?()
                } catch let error {
                    print(error)
                }
            }
        }
        
        private func savePhoto(for car: Car, shouldRemove: Bool) {
            if shouldRemove {
                RealmManager<Photo>()
                    .read()
                    .filter({ $0.carId == car.id })
                    .forEach({ RealmManager().delete(object: $0)})
            }
            
            self.imageListVM.items.forEach { image in
                guard let data = image.jpegData(compressionQuality: 1) else { return }
                let photo = Photo(car, image: data)
                RealmManager<Photo>().write(object: photo)
            }
        }
        
        func removeCar(completion: Completion?) {
            guard case let .edit(car) = mode else {
              return
            }
            RealmManager().delete(object: car, completion: completion)
        }
        
        private func initMode() {
            initValidator()

            switch mode {
            case .create, .createFrom:
                break
            case .edit(let object):
                brandFieldVM.text = object.brand
                modelFieldVM.text = object.model
                yearFieldVM.text = object.year.wrappedString
                winFieldVM.text = object.win.wrapped
                mileageFieldVM.text = object.mileage.toString()
                saveButtonVM.buttonVM.title = "Обновить"
                imageListVM.set(object.images)
                saveButtonVM.buttonVM.isEnabled = false
                initChangeChecker()
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
                .removeDuplicates()
                .sink { [weak self] value in
                    guard let self else { return }
                    let isEnable = value && (mode == .create ? true : self.changeChecker.hasChange)
                    self.saveButtonVM.buttonVM.isEnabled = isEnable
                }
                .store(in: &cancellables)
            
            changeChecker.formHasChange
                .removeDuplicates()
                .sink { [weak self] value in
                    guard let self else { return }
                    let isEnable = self.validator.isValid && !value
                    self.saveButtonVM.buttonVM.isEnabled = isEnable
                }
                .store(in: &cancellables)
            
            winFieldVM.inputVM.isValidSubject.sink { [weak self] value in
                self?.winFieldVM.actionImageVM?.isEnabled = value
                self?.decodeVIN()
            }
            .store(in: &cancellables)
        }
        
        private func initChangeChecker() {
            changeChecker.setForm([
                winFieldVM.inputVM,
                brandFieldVM.inputVM,
                modelFieldVM.inputVM,
                mileageFieldVM.inputVM,
                yearFieldVM.inputVM,
                imageListVM
            ])
        }
        
        private func initSuggestionAction() {
            brandFieldVM.actionImageVM = .init(
                action: { [weak self] in
                    guard let self else { return }
                    Task { @MainActor in
                        do {
                            self.isLoadind.send(true)
                            let result = try await NetworkManager
                                .sh
                                .request(
                                    GarageApi.brands,
                                    model: Wrapper<Brand>.self
                                ).result
                            self.suggestionCompletion?(result)
                            self.isLoadind.send(false)
                        } catch let error {
                            self.isLoadind.send(false)
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
                            self.isLoadind.send(true)
                            let result = try await NetworkManager
                                .sh
                                .request(
                                    GarageApi.models(brand: self.brandFieldVM.text),
                                    model: Wrapper<Model>.self
                                ).result
                            self.suggestionCompletion?(result)
                            self.isLoadind.send(false)
                        } catch let error {
                            self.isLoadind.send(false)
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
        
        func getLogoBy(_ brand: String) {
            Task { @MainActor in
                do {
                    self.isLoadind.send(true)
                    guard let url = URL(string: "https://pictures.shoop-vooop.cloudns.nz/cars-logos/api/images/\(brand.lowercased())_resized.png") else { return }
                    let request = URLRequest(url: url)
                    let (data, _) = try await URLSession.shared.data(for: request)
                    if let image = UIImage(data: data) {
                        self.logoImage = image
                    }
                    self.isLoadind.send(false)
                } catch let error {
                    self.isLoadind.send(false)
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
                    getLogoBy(data.value.wrapped)
                    modelFieldVM.actionImageVM?.isEnabled = true
                case .year:
                    yearFieldVM.text = data.value.wrapped
                }
            }
        }
    }
}
