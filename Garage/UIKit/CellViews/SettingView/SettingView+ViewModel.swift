//
//  SettingView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 17.06.23.
//

import Foundation

extension SettingView {
    final class ViewModel: BasicViewModel {
        let textLabelVM = BasicLabel.ViewModel(.text("Текст настройки"))
        
        init(point: SettingPoint) {
            super.init()
            textLabelVM.textValue = .text(point.rawValue)
        }
    }
}
