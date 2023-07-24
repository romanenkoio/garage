//
//  RangeDatePicker+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 2.06.23.
//

import Foundation
import Combine

extension RangeDatePicker {
    class ViewModel: BasicViewModel, Validatable {
        var rules: [ValidationRule] = .empty
        var isValid: Bool = false
        var isValidSubject: PassthroughSubject<Bool, Never> = .init()
        
        let desctiptionVM = BasicLabel.ViewModel()
        let startDateVM = BasicDatePicker.ViewModel(
            placeholder: "с \(Date().toString(.ddMMyy))"
        )
        let finishDateVM = BasicDatePicker.ViewModel(
            placeholder: "по \(Date().append(.month).toString(.ddMMyy))"
        )
        
        @Published private(set) var startDate: Date? {
            didSet {
                print("start set")
            }
        }
        @Published private(set) var endDate: Date? {
            didSet {
                print("end set")
            }
        }
        
        var minStartDate: Date? {
            get { startDateVM.minimumDate }
            set { startDateVM.minimumDate = newValue}
        }
        
        var minEndDate: Date? {
            get { finishDateVM.minimumDate }
            set { finishDateVM.minimumDate = newValue}
        }
        
        var maxStartDate: Date? {
            get { startDateVM.maximumDate }
            set { startDateVM.maximumDate = newValue}
        }
        
        var maxEndDate: Date? {
            get { finishDateVM.maximumDate }
            set { finishDateVM.maximumDate = newValue}
        }
        
        var titleDescription: String {
            get {
                startDateVM.datePickerController.descriptionLabelVM.textValue.clearText
                return finishDateVM.datePickerController.descriptionLabelVM.textValue.clearText
            }
            set {
                startDateVM.datePickerController.descriptionLabelVM = .init(.text(newValue))
                finishDateVM.datePickerController.descriptionLabelVM = .init(.text(newValue))
            }
        }
        
        func setDates(
            start: Date? = nil,
            end: Date? = nil
        ) {
            startDateVM.initDate(start)
            finishDateVM.initDate(end)
        }
        
        init(
            startDate: Date? = nil,
            endDate: Date? = nil
        ) {
            self.startDate = startDate
            self.endDate = endDate
            super.init()
            
            self.startDateVM.datePickerController.$date.sink { [weak self] date in
                guard let self, let date else { return }
                self.startDateVM.text = "c \(date.toString(.ddMMyy))"
                if let finishDate = self.finishDateVM.datePickerController.date, date >= finishDate {
                    self.finishDateVM.setNewDate(nil)
                }
                self.startDate = date
                self.validate()
            }
            .store(in: &cancellables)
            
            self.finishDateVM.datePickerController.$date.sink { [weak self] date in
                guard let self, let date else { return }
                self.endDate = date
                self.finishDateVM.text = "по \(date.toString(.ddMMyy))"
                self.validate()
            }
            .store(in: &cancellables)
        }
        
        @discardableResult
        func validate() -> Bool {
            guard let startDate,
                  let endDate,
                  startDate < endDate
            else {
                isValid = false
                isValidSubject.send(false)
                return false }
            
            isValid = true
            isValidSubject.send(true)
            return true
        }
        
        func silentVaidate() {
            guard let startDate,
                  let endDate,
                  startDate < endDate
            else {
                isValid = false
                return
            }
            
            isValid = true
        }
    }
}
