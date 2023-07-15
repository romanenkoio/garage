//
//  SettingView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 17.06.23.
//

import Foundation

extension SettingView {
    final class ViewModel: BasicViewModel {
        let textLabelVM = BasicLabel.ViewModel()
        let imageVM = BasicImageView.ViewModel()
        let switchVM = BasicSwitch.ViewModel()
        
        init(point: SettingPoint) {
            super.init()
            textLabelVM.textValue = .text(point.rawValue)
            imageVM.image = point.icon
            switchVM.isOn = point.state
            switchVM.isHidden = !point.isSwitch
        }
    }
}
