//
//  DocumentType.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation
import UIKit

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
        case .license:                  return "Водительские права"
        case .medical:                  return "Медицинская справка"
        case .insurance:                return "Страховка"
        case .carPasport:               return "Технический паспорт"
        case .techChek:                 return "Технический осмотр"
        case .unlisted(let string):     return string ?? ""
        }
    }
    
    var image: UIImage? {
        switch self {
        case .license:                  return UIImage(named: "license")
        case .medical:                  return UIImage(named: "medLicense")
        case .insurance:                return UIImage(named: "insuranse")
        case .carPasport:               return UIImage(named: "insuranse")
        case .techChek:                 return UIImage(named: "techDoc")
        case .unlisted:                 return nil
            
        }
    }
    
    init(from text: String) {
        switch text {
        case "Водительские права":      self = .license
        case "Медицинская справка":     self = .medical
        case "Страховка":               self = .insurance
        case "Технический паспорт":     self = .carPasport
        case "Технический осмотр":      self = .techChek
        default:                        self = .unlisted(text)
        }
    }
}
