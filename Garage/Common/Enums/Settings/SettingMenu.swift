//
//  SettingMenu.swift
//  Garage
//
//  Created by Illia Romanenko on 13.06.23.
//

import UIKit

enum SettingPoint: String, CaseIterable {
    case reminders = "Получать уведомления"
    case mileageReminder = "Напоминание о пробеге"
    case backup = "Резервная копия"
    case dataTransfer = "Перенос данных"
    case contactUs = "Связаться с нами"
    case version = "Версия: 1.0.0"

    var icon: UIImage? {
        switch self {
        case .reminders:        return UIImage(systemName: "bell.square.fill")
        case .mileageReminder:  return UIImage(systemName: "speedometer")
        case .backup:           return UIImage(systemName: "externaldrive.fill.badge.timemachine")
        case .dataTransfer:     return UIImage(systemName: "chevron.right.square.fill")
        case .contactUs:        return UIImage(systemName: "envelope.fill")
        case .version:           return UIImage(systemName: "info.circle.fill")
        }
    }
    
    var state: Bool {
        switch self {
        case .reminders:            return PushManager.sh.isEnable && (SettingsManager.sh.read(.useReminder) ?? true)
        case .mileageReminder:      return PushManager.sh.isEnable && (SettingsManager.sh.read(.useReminder) ?? false) && (SettingsManager.sh.read(.mileageReminder) ?? false)
        case .backup:               return false
        case .dataTransfer:         return false
        case .version, .contactUs:   return false
        }
    }
    
    var isSwitch: Bool {
        switch self {
        case .reminders, .mileageReminder:
            return true
        case .backup, .dataTransfer, .contactUs, .version:
            return false
        }
    }
    
    var title: String {
        switch self {
        case .reminders:        return "Получать уведомления"
        case .mileageReminder:  return "Напоминание о пробеге"
        case .backup:           return "Резервная копия"
        case .dataTransfer:     return "Перенос данных"
        case .contactUs:        return "Связаться с нами"
        case .version:          return "Версия: \(Bundle.main.version)"
        }
    }
}
