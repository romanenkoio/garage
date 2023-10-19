//
//  StatisticType.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 28.08.23.
//

import Foundation

enum StatisticType: Equatable, CaseIterable {
    case statistic
    case charts
    
    var title: String {
        switch self {
            case .charts:      return "Грaфики"
            case .statistic:   return "Статистика"
        }
    }
}

