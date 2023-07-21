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
        case .oil:                  return "Масло двигателя".localized
        case .gearOil:              return "Масло коробки передач".localized
        case .engineFilter:         return "Воздушный фильтр".localized
        case .brakePads:            return "Тормозные колодки".localized
        case .brakeDisk:            return "Тормозные диски".localized
        case .belt:                 return "Ремень/цепь".localized
        case .airFilter:            return "Салонный фильтр".localized
        case .spark:                return "Свечи".localized
        case .battery:              return "Аккумулятор".localized
        case .unlisted(let name):   return name ?? ""
        }
    }
}
