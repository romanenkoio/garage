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
        var components: DateComponents
        
        init(date: DateComponents) {
            self.components = date
            
            if self.components.year == Date().components.year {
                labelVM.textValue = .text("В этом году")
            } else if let year = components.year {
                labelVM.textValue = .text(year.toString())
            }
        }
    }
}
