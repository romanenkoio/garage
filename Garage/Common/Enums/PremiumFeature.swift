//
//  PremiumFeature.swift
//  Garage
//
//  Created by Illia Romanenko on 30.07.23.
//

import Foundation

enum PremiumFeatures: CaseIterable {
    case unlimitedCar
    case unlimitedReminder
    case unlimitedDocuments
    case statistic
    case ads
    
    var title: String {
        switch self {
        case .unlimitedCar:         return "•  Неограниченое количество машин"
        case .unlimitedReminder:    return "•  Безлимитное планирование"
        case .unlimitedDocuments:   return "•  Безлимитное создание документов"
        case .statistic:            return "•  Статистика расходов по автомобилю"
        case .ads:                  return "•  Отстутствие рекламы"
        }
    }
}
