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
            settingsPoint = [
                [.reminders],
                [.backup],
                [.contactUs, .language]
            ]
            
            if !Environment.isPrem {
                settingsPoint.insert([.banner], at: 0)
                settingsPoint.insert([.subscription, .getPremium(false)], at: 1)
            } else {
                settingsPoint.insert([.subscription], at: 0)
            }
            
#if DEBUG
            if Environment.isPrem {
                settingsPoint.remove(at: 0)
                settingsPoint.insert([.subscription, .getPremium(Environment.isPrem)], at: 1)
            }
#endif
            
            tableVM.setCells(settingsPoint)
        }
    }
}
