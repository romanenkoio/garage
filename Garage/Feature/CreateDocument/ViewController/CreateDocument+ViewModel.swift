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
        
        let datePickerVM = RangeDatePicker.ViewModel()
        let typeFieldVM = BasicInputView.ViewModel(
            errorVM: .init(error: "Не может быть пустым"),
            inputVM: .init(placeholder: "Тип документа")
        )
        
        var suggestionCompletion: SelectArrayCompletion?
        var saveCompletion: Completion?

        override init() {
            super.init()
            
            typeFieldVM.actionImageVM = .init(
                action: { [ weak self] in
                    self?.suggestionCompletion?(DocumentType.allCases)
                }, isEnable: true
            )
            
            saveButtonVM.action = .touchUpInside { [weak self] in
                guard let self else { return }
                let document = Document(
                    rawType: self.typeFieldVM.text,
                    startDate: self.datePickerVM.startDate,
                    endDate: self.datePickerVM.endDate,
                    photo: nil
                )
                RealmManager<Document>().write(object: document)
                self.saveCompletion?()
            }
            
            validator.setForm([typeFieldVM.inputVM, datePickerVM])
            
            validator.formIsValid
                .sink { [weak self] value in
                self?.saveButtonVM.isEnabled = value
            }
            .store(in: &cancellables)
        }
    }
}
