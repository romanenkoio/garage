//
//  FAQType.swift
//  Garage
//
//  Created by Illia Romanenko on 11.09.23.
//

import Foundation

enum Liquid: CaseIterable, FAQDisplayable {
    case motorOil
    case aTransmissionOil
    case mTransmissionOil
    case coolant
    case breakFluid
    case hydraulicFluid

    var header: String {
        return "Жидкости"
    }

    var title: String {
        switch self {
        case .motorOil:             return "Моторное масло"
        case .aTransmissionOil:     return "Масло АКПП"
        case .mTransmissionOil:     return "Масло МКПП"
        case .coolant:              return "Охлаждающая жидкость"
        case .breakFluid:           return "Тормозная жидкость"
        case .hydraulicFluid:       return "Жидкость ГУР"
        }
    }
    
    var peroid: String {
        switch self {
        case .motorOil:             return "8 т./км"
        case .aTransmissionOil:     return "60 т./км"
        case .mTransmissionOil:     return "100 т./км"
        case .coolant:              return "50 т./км или 2-3 года"
        case .breakFluid:           return "40 т./км или раз в 2 года"
        case .hydraulicFluid:       return "40 т./км"
        }
    }
}

enum Filters: CaseIterable, FAQDisplayable {
    case fuel
    case air
    case cabin
    
    var header: String {
        return "Фильтры"
    }

    var title: String {
        switch self {
        case .fuel:     return "Топливный фильтр"
        case .air:      return "Воздушный фильтр"
        case .cabin:    return "Салонный фильтр"
        }
    }
    
    var peroid: String {
        switch self {
        case .fuel:     return "20 т./км"
        case .air:      return "10-12 т./км или один раз в год"
        case .cabin:    return "10 т./км"
        }
    }
}

enum Electro: CaseIterable, FAQDisplayable {
    case battery
    case sparkPlug
    
    var header: String {
        return "Электрика"
    }
    
    var title: String {
        switch self {
        case .battery:      return "Аккумулятор"
        case .sparkPlug:    return "Свечи зажигания"
        }
    }
    
    var peroid: String {
        switch self {
        case .battery:      return "3-4 года"
        case .sparkPlug:    return "45 т./км"
        }
    }
}

enum Mechanic: CaseIterable, FAQDisplayable {
    case grm
    
    var header: String {
        return "Механика"
    }

    var title: String {
        switch self {
        case .grm:  return "Комлпект ГРМ"
        }
    }
    
    var peroid: String {
        switch self {
        case .grm:  return "80 т./км"
        }
    }
}

protocol FAQDisplayable {
    var title: String { get }
    var peroid: String { get }
    var header: String { get }
}
