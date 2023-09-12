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
            DispatchQueue.global().sync { [weak self] in
                Storage.remove(.backup, from: .documents)
                DispatchQueue.main.async { [weak self] in
                    self?.setCells()
                }
            }
        }
        
        func reload(completion: @escaping (String) -> Void) {
            DispatchQueue.global().async { [weak self] in
                guard let backup = Storage.retrieve(.backup, from: .documents, as: Backup.self) else {
                    self?.settingsPoint = [
                        [.backup("отсутствует"), .transfer(false)],
                        [.save, .restore(false), .remove(false)]
                    ]
                    self?.setCells()
                    completion("отсутствует")
                    return
                }
                
                let date = backup.date.toString(.ddMMyy)
                self?.settingsPoint = [
                    [.backup(date), .transfer(true)],
                    [.save, .restore(true), .remove(true)]
                ]
                self?.setCells()
                
                DispatchQueue.main.async {
                    completion(date)
                }
            }
        }
    }
}
