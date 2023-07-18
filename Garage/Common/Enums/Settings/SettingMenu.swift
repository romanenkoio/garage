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
    case backup = "Данные"
    case contactUs = "Связаться с нами"
    case version = "Версия: 1.0.0"
    case language

    var icon: UIImage? {
        switch self {
        case .reminders:        return UIImage(systemName: "bell.square.fill")
        case .mileageReminder:  return UIImage(systemName: "speedometer")
        case .backup:           return UIImage(systemName: "externaldrive.fill.badge.timemachine")
        case .contactUs:        return UIImage(systemName: "envelope.fill")
        case .version:           return UIImage(systemName: "info.circle.fill")
        case .language:           return UIImage(systemName: "info.circle.fill")
        }
    }
    
    var state: Bool {
        switch self {
        case .reminders:            return PushManager.sh.isEnable && (SettingsManager.sh.read(.useReminder) ?? true)
        case .mileageReminder:      return PushManager.sh.isEnable && (SettingsManager.sh.read(.useReminder) ?? false) && (SettingsManager.sh.read(.mileageReminder) ?? false)
        case .backup, .language:     return false
        case .version, .contactUs:   return false
        }
    }
    
    var isSwitch: Bool {
        switch self {
        case .reminders, .mileageReminder:
            return true
        case .backup, .contactUs, .version, .language:
            return false
        }
    }
    
    var title: String {
        switch self {
        case .reminders:        return "Получать уведомления"
        case .mileageReminder:  return "Напоминание о пробеге"
        case .backup:           return "Данные"
        case .contactUs:        return "Связаться с нами"
        case .version:          return "Версия: \(Bundle.main.version)"
        case .language:          return "Язык"
        }
    }
}
