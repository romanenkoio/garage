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
            [.subscription],
            [.reminders, .mileageReminder],
            [.backup],
            [.contactUs, .version, .language]
        ]
        
        override init() {
            super.init()
            setCells()
        }
        
        func setCells() {
            tableVM.setCells(settingsPoint)
        }
    }
}
