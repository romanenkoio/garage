//
//  SettingView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 17.06.23.
//

import Foundation
import Combine

extension SettingView {
    final class ViewModel: BasicViewModel {
        let textLabelVM = BasicLabel.ViewModel()
        let imageVM: BasicImageView.ViewModel
        let switchVM = BasicSwitch.ViewModel()
        
        var switchCompletion: ((Bool) -> Void)?
        @Published var isEnabled: Bool?
        
        init(point: SettingPoint) {
            imageVM = .init(image: point.icon)
            super.init()
            textLabelVM.textValue = .text(point.title)
          
            switchVM.isOn = point.state
            switchVM.isHidden = !point.isSwitch
        }
        
        init(point: DataSubSetting) {
            imageVM = .init(image: point.icon)
            super.init()
            textLabelVM.textValue = .text(point.title)
            switchVM.isOn = point.state
            switchVM.isHidden = !point.isSwitch
            isEnabled = point.isEnabled
        }
    }
}
