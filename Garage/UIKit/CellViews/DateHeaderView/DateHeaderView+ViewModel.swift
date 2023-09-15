//
//  DateHeaderView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 18.07.23.
//

import Foundation

extension DateHeaderView {
    final class ViewModel: BasicViewModel {
        let labelVM = BasicLabel.ViewModel()
        var components: DateComponents?
        
        init(textValue: TextValue) {
            self.labelVM.textValue = textValue
        }
        
        init(date: DateComponents) {
            self.components = date
            guard let components else { return }
            if components.month != nil {
                var newComponent = components
                newComponent.day = 1
                guard let date = Calendar.current.date(from: newComponent) else {
                    if let year = newComponent.year {
                        labelVM.textValue = .text(year.toString())
                    } else {
                        labelVM.textValue = .text(Date().getDateComponent(.year)!.toString())
                    }
                    return
                }
                let month = date.monthName()
                if let year = newComponent.year {
                    if year == Date().components.year {
                        labelVM.textValue = .text(month)
                    } else {
                        labelVM.textValue = .text("\(year), \(month)")
                    }
                }
            } else {
                if self.components?.year == Date().components.year {
                    labelVM.textValue = .text("В этом году")
                } else if let year = components.year {
                    labelVM.textValue = .text(year.toString())
                }
            }
        }
    }
}
