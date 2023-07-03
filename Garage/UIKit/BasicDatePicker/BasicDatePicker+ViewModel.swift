//
//  BasicDatePicker+ViewModel.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 31.05.23.
//

import UIKit

extension BasicDatePicker {
    class ViewModel: BasicTextField.ViewModel {
        @Published private(set) var date: Date?
    
        @Published var minimumDate: Date?
        @Published var maximumDate: Date?

        init(
            date: Date? = nil,
            placeholder: String = .empty
        ) {
            super.init(
                text: date?.toString(.ddMMyy) ?? .empty,
                placeholder: Date().append(.day).toString(.ddMMyy)
            )
            self.date = date
            self.checkedValue = date?.withoutTime.toString(.ddMMyy)
            self.placeholder = placeholder
        }
        
        func setNewDate(_ date: Date?) {
            let stringDate = date?.withoutTime.toString(.ddMMyy) ?? .empty
            self.date = date
            self.text = stringDate
            
            guard let date else {
                hasChange = checkedValue != stringDate
                hasChangeSubject.send(checkedValue != stringDate)
                return
            }
            
            self.checkChanged(stringDate)
        }
        
        func initDate(_ date: Date?) {
            self.date = date
            self.checkedValue = date?.withoutTime.toString(.ddMMyy)
        }
    }
}
