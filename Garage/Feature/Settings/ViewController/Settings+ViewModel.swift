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
        let tableVM = BasicTableView.GenericViewModel<SettingPoint>()
        
        override init() {
            super.init()
            tableVM.setCells(SettingPoint.allCases)
        }
    }
}
