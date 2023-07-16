//
//  DataSubSetting.swift
//  Garage
//
//  Created by Illia Romanenko on 16.07.23.
//

import UIKit

enum DataSubSetting {
    case transfer
    case backup(String)
    case save
    case restore
    case remove
    
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
        case .transfer:             return "Перенос данных"
        case .backup(let date):     return "Резервная копия: \(date)"
        case .save:                 return "Создать копию"
        case .restore:              return "Восстановить из копии"
        case .remove:               return "Удалить копию"
        }
    }
}
