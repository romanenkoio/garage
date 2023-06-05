//
//  RangeDatePicker+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 2.06.23.
//

import Foundation

extension RangeDatePicker {
    class ViewModel: BasicViewModel {
        
        let startDateVM = BasicDatePicker.ViewModel(
            placeholder: "с \(Date().formatData(formatType: .ddMMyy))"
        )
        let finishDateVM = BasicDatePicker.ViewModel(
            placeholder: "по \(Date().append(.month).formatData(formatType: .ddMMyy))"
        )
        
        @Published private(set) var startDate: Date?
        @Published private(set) var endDate: Date?
        
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
        
        func setDates(
            start: Date? = nil,
            end: Date? = nil
        ) {
            startDateVM.setDate(start)
            finishDateVM.setDate(end)
        }
        
        init(
            startDate: Date? = nil,
            endDate: Date? = nil
        ) {
            self.startDate = startDate
            self.endDate = endDate
            super.init()
            
            self.startDateVM.$date.sink { [weak self] date in
                guard let self, let date else { return }
                self.startDateVM.text = "c \(date.formatData(formatType: .ddMMyy))"
                
                if let finishDate = self.finishDateVM.date, date >= finishDate {
                    self.finishDateVM.setDate(nil)
                }
            }
            .store(in: &cancellables)
            
            self.finishDateVM.$date.sink { [weak self] date in
                guard let self, let date else { return }
                self.finishDateVM.text = "по \(date.formatData(formatType: .ddMMyy))"
            }
            .store(in: &cancellables)
        }
        
        
    }
}
