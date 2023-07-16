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
        
        let settingsPoint: [[DataSubSetting]] = [
            [.backup, .transfer],
            [.save, .restore, .remove]
        ]
        
        override init() {
            super.init()
            setCells()
        }
        
        func setCells() {
            tableVM.setCells(settingsPoint)
        }
        
        func saveBackup() {
            Storage.store(Backup(), to: .documents, as: .backup)
            setCells()
        }
        
        func restoreBackup() {
            guard let backup = Storage.retrieve(.backup, from: .documents, as: Backup.self) else { return }
            RealmManager().removeAll()
            backup.saveCurrent()
        }
        
        func removeBackup() {
            Storage.remove(.backup, from: .documents)
            setCells()
        }
    }
}
