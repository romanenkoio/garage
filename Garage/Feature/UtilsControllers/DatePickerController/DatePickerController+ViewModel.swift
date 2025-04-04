//
//  DatePickerController+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 24.07.23.
//

import Foundation

extension DatePickerController {
    class ViewModel: BasicViewModel {
        var closeButtonVM = BasicButton.ViewModel()
        var saveButtonVM = BasicButton.ViewModel()
        var descriptionLabelVM: BasicLabel.ViewModel
        
        @Published var date: Date?
        @Published var minimumDate: Date?
        @Published var maximumDate: Date?
        @Published var isBeingDismissed: Bool = false
        
        init(
            date: Date = Date(),
            descriptionLabelVM: BasicLabel.ViewModel = .init()
        ) {
            self.date = date
            self.descriptionLabelVM = descriptionLabelVM
            super.init()
        }
    }
}
