//
//  BasicDatePicker+ViewModel.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 31.05.23.
//

import UIKit

extension BasicDatePicker {
    class ViewModel: BasicTextField.ViewModel {
        let desctiptionVM = BasicLabel.ViewModel()
        var datePickerController = DatePickerController.ViewModel()
        @Published private(set) var date: Date?

        init(
            date: Date? = nil,
            placeholder: String = .empty
        ) {
            super.init(
                text: date?.toString(.ddMMyy) ?? .empty,
                placeholder: Date().append(.day).toString(.ddMMyy)
            )
            self.isValid = date != nil
            self.date = date
            self.checkedValue = date?.withoutTime.toString(.ddMMyy)
            self.placeholder = placeholder
            
            datePickerController.$date
                .dropFirst()
                .sink { [weak self] date in
                    guard let self else { return}
                    setNewDate(date)
                }
                .store(in: &cancellables)
        }
        
        func setNewDate(_ date: Date?) {
            let stringDate = date?.withoutTime.toString(.ddMMyy) ?? .empty
            self.date = date
            self.text = stringDate
            
            guard date != nil else {
                hasChange = checkedValue != stringDate
                hasChangeSubject.send(checkedValue != stringDate)
                return
            }
            
            self.validate()
            self.checkChanged(stringDate)
        }
        
        func initDate(_ date: Date?) {
            self.date = date
            self.datePickerController.date = date
            self.text = date?.withoutTime.toString(.ddMMyy) ?? .empty
            self.isValid = date != nil
            
            self.checkedValue = date?.withoutTime.toString(.ddMMyy)
        }
        
        var minimumDate: Date? {
            get { datePickerController.minimumDate }
            set { datePickerController.minimumDate = newValue }
        }
        
        var maximumDate: Date? {
            get { datePickerController.maximumDate }
            set { datePickerController.maximumDate = newValue }
        }
        
        var descriptionLabel: String {
            get {datePickerController.descriptionLabelVM.textValue.clearText}
            set {datePickerController.descriptionLabelVM = .init(.text(newValue))}
        }
    }
}
