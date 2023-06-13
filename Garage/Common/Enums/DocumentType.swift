//
//  DocumentType.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

enum DocumentType: CaseIterable, Selectable, Equatable {
    case license
    case medical
    case insurance
    case carPasport
    case techChek
    case unlisted(String?)

    static var allCases: [DocumentType] = [
        .license,
        .medical,
        .insurance,
        .carPasport,
        .techChek
    ]

    var title: String {
        switch self {
        case .license:                  return "Права"
        case .medical:                  return "Медицинская справка"
        case .insurance:                return "Страховка"
        case .carPasport:               return "Технический паспорт"
        case .techChek:                 return "Технический осмотр"
        case .unlisted(let string):     return string ?? ""
        }
    }
    
    init(from text: String) {
        switch text {
        case "Права":                   self = .license
        case "Медицинская справка":     self = .medical
        case "Страховка":               self = .insurance
        case "Технический паспорт":     self = .carPasport
        case "Технический осмотр":      self = .techChek
        default:                        self = .unlisted(text)
        }
    }
}
