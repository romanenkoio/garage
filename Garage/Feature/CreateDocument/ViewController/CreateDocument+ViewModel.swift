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
        let saveButtonVM = BasicButton.ViewModel(
            title: "Сохранить",
            isEnabled: false,
            style: .primary
        )
        
        let imageList = BasicImageListView.ViewModel()
        let datePickerVM = RangeDatePicker.ViewModel()
        let typeFieldVM = SuggestionInput<DocumentType>.GenericViewModel<DocumentType>(
            DocumentType.allCases,
            items: { items in items.map({ ($0.title, $0.image) })},
            errorVM: .init(error: "Не может быть пустым"),
            inputVM: .init(placeholder: "Права"),
            isRequired: true
        )
        
        var suggestionCompletion: SelectArrayCompletion?
        var saveCompletion: Completion?

        override init() {
            super.init()
            
            saveButtonVM.action = .touchUpInside { [weak self] in
                guard let self else { return }
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
                self.saveCompletion?()
            }
            imageList.editingEnabled = true
            
            validator.setForm([typeFieldVM.inputVM, datePickerVM])
            
            validator.formIsValid
                .sink { [weak self] value in
                self?.saveButtonVM.isEnabled = value
            }
            .store(in: &cancellables)
        }
    }
}
