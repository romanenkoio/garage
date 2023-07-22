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
        case .transfer:         return UIImage(systemName: "bell.square.fill")
        case .backup:           return UIImage(systemName: "speedometer")
        case .save:             return UIImage(systemName: "externaldrive.fill.badge.timemachine")
        case .restore:          return UIImage(systemName: "chevron.right.square.fill")
        case .remove:           return UIImage(systemName: "trash")
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
