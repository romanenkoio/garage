//
//  Backup+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 16.07.23.
//  
//

import UIKit

extension BackupViewController {
    final class ViewModel: BasicViewModel {
        let tableVM = BasicTableView.SectionViewModel<DataSubSetting>()
        
        var settingsPoint: [[DataSubSetting]] = []
        
        init(points: [[DataSubSetting]]) {
            super.init()
            self.settingsPoint = points
        }
        
        func setCells() {
            tableVM.setCells(settingsPoint)
        }
        
        func removeBackup() {
            Storage.remove(.backup, from: .documents)
            setCells()
        }
    }
}
