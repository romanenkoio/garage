//
//  SettingMenu.swift
//  Garage
//
//  Created by Illia Romanenko on 13.06.23.
//

import UIKit

enum SettingPoint {
    case subscription
    case getPremium(Bool)
    case reminders
    case mileageReminder
    case backup
    case contactUs
    case version
    case language

    var icon: UIImage? {
        switch self {
        case .getPremium:     return UIImage(systemName: "bell.square.fill")
        case .subscription:     return UIImage(systemName: "bell.square.fill")
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
        case .subscription:                 return false
        case .getPremium(let value):        return value
        case .reminders:                    return PushManager.sh.isEnable && (SettingsManager.sh.read(.useReminder) ?? true)
        case .mileageReminder:              return PushManager.sh.isEnable && (SettingsManager.sh.read(.useReminder) ?? false) && (SettingsManager.sh.read(.mileageReminder) ?? false)
        case .backup, .language:            return false
        case .version, .contactUs:          return false
        }
    }
    
    var isSwitch: Bool {
        switch self {
        case .reminders, .mileageReminder, .getPremium:
            return true
        case .backup, .contactUs, .version, .language, .subscription:
            return false
        }
    }
    
    var title: String {
        switch self {
        case .subscription:     return "ТипАккаунта".localized((SettingsManager.sh.read(.isPremium) ?? false) ? "премиум".localized : "базовый".localized)
        case .reminders:        return "Получать уведомления".localized
        case .mileageReminder:  return "Напоминание о пробеге".localized
        case .backup:           return "Резервная копия".localized
        case .contactUs:        return "Связаться с нами".localized
        case .version:          return "Версия".localized(Bundle.main.version)
        case .language:         return "Язык".localized
        case .getPremium:       return "Получить премиум".localized
        }
    }
}
