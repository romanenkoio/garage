//
//  Settings+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//  
//

import UIKit

extension SettingsViewController {
    final class ViewModel: BasicViewModel {
        let tableVM = BasicTableView.SectionViewModel<SettingPoint>()
        
        let settingsPoint: [[SettingPoint]] = [
            [.accountInfo, .contactUs],
            [.mileageReminder, .distancePoints],
            [.dataTransfer]
        ]
        
        override init() {
            super.init()
            tableVM.setCells(settingsPoint)
        }
    }
}
