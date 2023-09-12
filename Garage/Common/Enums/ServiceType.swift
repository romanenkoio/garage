//
//  ServiceType.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

enum ServiceType: CaseIterable, Equatable {
    case oil
    case gearOil
    case engineFilter
    case brakePads
    case brakeDisk
    case belt
    case airFilter
    case spark
    case battery
    case unlisted(String?)

    static var allCases: [ServiceType] = [
        .oil,
        .gearOil,
        .engineFilter,
        .brakePads,
        .brakeDisk,
        .belt,
        .airFilter,
        .spark,
        .battery
    ]
    
    var title: String {
        switch self {
        case .oil:                  return "Масло двигателя"
        case .gearOil:              return "Масло коробки передач"
        case .engineFilter:         return "Воздушный фильтр"
        case .brakePads:            return "Тормозные колодки"
        case .brakeDisk:            return "Тормозные диски"
        case .belt:                 return "Ремень/цепь"
        case .airFilter:            return "Салонный фильтр"
        case .spark:                return "Свечи"
        case .battery:              return "Аккумулятор"
        case .unlisted(let name):   return name ?? ""
        }
    }
}
