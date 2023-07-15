//
//  SettingMenu.swift
//  Garage
//
//  Created by Illia Romanenko on 13.06.23.
//

import UIKit

enum SettingPoint: String, CaseIterable {
    case reminders = "Получать напоминания"
    case mileageReminder = "Напоминание о пробеге"
    case backup = "Резервная копия"
    case dataTransfer = "Перенос данных"

    var icon: UIImage? {
        switch self {
        case .reminders:        return UIImage(systemName: "bell.square.fill")
        case .mileageReminder:  return UIImage(systemName: "speedometer")
        case .backup:           return UIImage(systemName: "externaldrive.fill.badge.timemachine")
        case .dataTransfer:     return UIImage(systemName: "chevron.right.square.fill")
        }
    }
    
    var state: Bool {
        switch self {
        case .reminders:            return PushManager.sh.isEnable
        case .mileageReminder:      return false
        case .backup:               return false
        case .dataTransfer:         return false
        }
    }
}
