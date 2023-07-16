//
//  Settings+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//  
//

import UIKit
import Cirrus

extension SettingsViewController {
    final class ViewModel: BasicViewModel {
        let tableVM = BasicTableView.SectionViewModel<SettingPoint>()
        
        let settingsPoint: [[SettingPoint]] = [
            [.reminders, .mileageReminder],
            [.backup, .dataTransfer],
            [.contactUs, .version]
        ]
        
        override init() {
            super.init()
            setCells()
        }
        
        func setCells() {
            tableVM.setCells(settingsPoint)
        }
        
        func uploadModel() {
            
        }
    }
}
