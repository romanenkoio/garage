//
//  CreateDocument+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//  
//

import UIKit

extension CreateDocumentViewController {
    final class ViewModel: BasicControllerModel {
        let saveButtonVM = AlignedButton.ViewModel(
            buttonVM: .init(
                title: "Сохранить",
                isEnabled: false,
                style: .primary
            ))
        
        let imageList = BasicImageListView.ViewModel()
        let datePickerVM = RangeDatePicker.ViewModel()
        let typeFieldVM = SuggestionInput<DocumentType>.GenericViewModel<DocumentType>(
            DocumentType.allCases,
            items: { items in items.map({ ($0.title, $0.image) })},
            errorVM: .init(error: "Не может быть пустым"),
            inputVM: .init(placeholder: "Водительские права"),
            isRequired: true
        )
        
        var suggestionCompletion: SelectArrayCompletion?
        var saveCompletion: Completion?

        var mode: EntityStatus<Document>
        
        init(mode: EntityStatus<Document>) {
            self.mode = mode
            super.init()
            initMode()
            
            saveButtonVM.buttonVM.action = .touchUpInside { [weak self] in
                guard let self else { return }
                switch mode {
                case .create:
                    save()
                case .edit(let object):
                    edit(object)
                }
                self.saveCompletion?()
            }
            imageList.editingEnabled = true
            imageList.description = "Добавить фото"
        }
        
        private func initValidator() {
            validator.setForm([typeFieldVM.inputVM, datePickerVM])
            
            validator.formIsValid
                .sink { [weak self] value in
                    guard let self else { return }

                    self.saveButtonVM.buttonVM.isEnabled = value && (mode == .create ? true : self.changeChecker.hasChange)
            }
            .store(in: &cancellables)
            
            changeChecker.formHasChange
                .removeDuplicates().sink { [weak self] value in
                    guard let self else { return }
                    self.saveButtonVM.buttonVM.isEnabled = self.validator.isValid && !value

                }
                .store(in: &cancellables)
        }
        
        func initMode() {
            initValidator()
            imageList.editingEnabled = mode != .create
            guard case let .edit(document) = mode else {
              return
            }
            
            self.imageList.items = document.photos
            self.datePickerVM.setDates(start: document.startDate, end: document.endDate)
            typeFieldVM.text = document.type.title
            
            changeChecker.setForm([
                typeFieldVM.inputVM
            ])
        }
        
        private func save() {
            let document = Document(
                rawType: self.typeFieldVM.text,
                startDate: self.datePickerVM.startDate,
                endDate: self.datePickerVM.endDate,
                photo: nil
            )
            RealmManager<Document>().write(object: document)
            
            self.imageList.items.forEach { image in
                guard let data = image.jpegData(compressionQuality: 1) else { return }
                let photo = Photo(document, image: data)
                RealmManager<Photo>().write(object: photo)
            }
        }
        
        private func edit(_ doc: Document) {
            guard case let .edit(document) = mode else {
              return
            }
            
            RealmManager<Document>().update { [weak self] realm in
                do {
                    try realm.write { [weak self] in
                        guard let self else { return }
                        document.rawType = typeFieldVM.text
                        document.startDate = datePickerVM.startDate
                        document.endDate = datePickerVM.endDate
                    }
                } catch let error {
                    print(error)
                }
            }
            
        }
            
        func removeCar() {
            guard case let .edit(service) = mode else {
              return
            }
            RealmManager().delete(object: service)
        }
    }
}
