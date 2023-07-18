//
//  DateHeaderView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 18.07.23.
//

import Foundation

extension DateHeaderView {
    final class ViewModel: BasicViewModel {
        let labelVM: BasicLabel.ViewModel
        let date: DateComponents
        
        init(date: DateComponents) {
            self.date = date
            labelVM = .init(.text("Год"))
        }
    }
}
