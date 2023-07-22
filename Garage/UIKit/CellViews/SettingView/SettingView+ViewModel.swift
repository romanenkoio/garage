//
//  SettingView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 17.06.23.
//

import UIKit
import Combine

extension SettingView {
    final class ViewModel: BasicViewModel {
        let textLabelVM = BasicLabel.ViewModel()
        let imageVM: BasicImageView.ViewModel
        let switchVM = BasicSwitch.ViewModel()
        let arrovImageVM = BasicImageView.ViewModel(image: UIImage(named: "simple_arrow_ic"))
        
        
        var switchCompletion: ((Bool) -> Void)?
        @Published var isEnabled: Bool?
        
        init(point: SettingPoint) {
            imageVM = .init(image: point.icon)
            super.init()
            textLabelVM.textValue = .text(point.title)
          
            switchVM.isOn = point.state
            switchVM.isHidden = !point.isSwitch
            arrovImageVM.isHidden = point.isSwitch
        }
        
        init(point: DataSubSetting) {
            imageVM = .init(image: point.icon)
            super.init()
            imageVM.isHidden = point.icon == nil
            textLabelVM.textValue = .text(point.title)
            switchVM.isOn = point.state
            switchVM.isHidden = !point.isSwitch
            isEnabled = point.isEnabled
            arrovImageVM.isHidden = point.isSwitch
            
            switch point {
            case .backup:
                textLabelVM.textColor = AppColors.tabbarIcon
                arrovImageVM.isHidden = true
                imageVM.isHidden = true
            default:
                textLabelVM.textColor = AppColors.black
                imageVM.isHidden = false
            }
        }
    }
}
