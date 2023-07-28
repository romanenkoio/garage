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
        let versionLabelVM = BasicLabel.ViewModel(.text(Bundle.main.version))
        
        var settingsPoint: [[SettingPoint]] = []
        
        override init() {
            super.init()
            setCells()
        }
        
        func setCells() {
            let isPremium: Bool = (SettingsManager.sh.read(.isPremium) ?? false)
            settingsPoint = [
                [.subscription, .getPremium(isPremium)],
                [.reminders],
                [.backup],
                [.contactUs, .language]
            ]
            
            if !isPremium {
                settingsPoint.insert([.banner], at: 0)
            }
            
            tableVM.setCells(settingsPoint)
        }
    }
}
