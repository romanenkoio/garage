//
//  DocumentType.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

enum DocumentType: CaseIterable {
    case license
    case medical
    case insurance
    case carPasport
    case unlisted(String?)

    static var allCases: [DocumentType] = [
        .license,
        .medical,
        .insurance,
        .carPasport,
        .unlisted(nil)
    ]

    var title: String {
        switch self {
        case .license:                  return "Права"
        case .medical:                  return "Медицинская справка"
        case .insurance:                return "Страховка"
        case .carPasport:               return "Технический паспорт"
        case .unlisted(let string):     return string ?? ""
        }
    }
    
    init(from text: String) {
        switch text {
        case "Права":                   self = .license
        case "Медицинская справка":     self = .medical
        case "Страховка":               self = .insurance
        case "Технический паспорт":     self = .carPasport
        default:                        self = .unlisted(text)
        }
    }
  
}
