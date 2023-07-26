//
//  DataSubSetting.swift
//  Garage
//
//  Created by Illia Romanenko on 16.07.23.
//

import UIKit

enum DataSubSetting {
    case backup(String)
    case transfer(Bool)
    case save
    case restore(Bool)
    case remove(Bool)
    
    var icon: UIImage? {
        switch self {
        case .transfer:         return UIImage(named: "data_transfer_ic")
        case .backup:           return nil
        case .save:             return UIImage(named: "create_backup_ic")
        case .restore:          return UIImage(named: "restore_backup_ic")
        case .remove:           return UIImage(named: "remove_backup_ic")
        }
    }
    
    var state: Bool {
       return false
    }
    
    var isSwitch: Bool {
       return false
    }
    
    var title: String {
        switch self {
        case .transfer:             return "Перенос данных".localized
        case .backup(let date):     return "Резервная копия_".localized(date)
        case .save:                 return "Создать копию".localized
        case .restore:              return "Восстановить из копии".localized
        case .remove:               return "Удалить копию".localized
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .backup:
            return true
        case .transfer(let value):
            return value
        case .save:
            return true
        case .restore(let value):
            return value
        case .remove(let value):
            return value
        }
    }
}
