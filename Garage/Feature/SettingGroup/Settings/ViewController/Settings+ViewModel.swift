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
                [.contactUs, .faq]
            ]
            
            if !Environment.isPrem {
                settingsPoint.insert([.banner], at: 0)
                settingsPoint.insert([.subscription, .getPremium(false), .promo], at: 1)
            } else {
                settingsPoint.insert([.subscription], at: 0)
            }
            
            tableVM.setCells(settingsPoint)
        }
        
        @discardableResult
        func checkPromo(code: String) -> Bool {
            let promos = Promocode.allCases.map({ $0.rawValue.lowercased() })
            let isValid = promos.contains(code.lowercased())
            if isValid {
                guard let type = Promocode(rawValue: code.uppercased()) else { return false }
                
                switch type {
                case .sale:
                    break
                    // TODO: Handle sale purchase
                case .life:
                    SettingsManager.sh.write(value: true, for: .isPromoPrem)
                }
            }
            return isValid
        }
    }
}
