//
//  BasicDatePicker+ViewModel.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 31.05.23.
//

import UIKit

extension BasicDatePicker {
    class ViewModel: BasicViewModel {
        @Published private(set) var date: Date?
        @Published var text: String = .empty
        @Published var placeholder: String?
        @Published var minimumDate: Date?
        @Published var maximumDate: Date?

        init(
            date: Date? = nil,
            placeholder: String
        ) {
            self.date = date
            self.placeholder = placeholder
        }
        
        func setDate(_ date: Date?) {
            self.date = date
        }
    }
}
