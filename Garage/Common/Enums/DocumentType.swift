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
    case pass
    case unlisted(String?)

    static var allCases: [DocumentType] = [
        .license,
        .medical,
        .insurance,
        .carPasport,
        .techChek,
        .pass
    ]

    var title: String {
        switch self {
        case .license:                  return "Водительское удостоверение"
        case .medical:                  return "Медицинская справка"
        case .insurance:                return "Страховка"
        case .carPasport:               return "Технический паспорт"
        case .techChek:                 return "Технический осмотр"
        case .pass:                     return "Пропуск"
        case .unlisted(let string):     return string ?? ""
        }
    }
    
    var image: UIImage? {
        switch self {
        case .license:                  return UIImage(named: "license")
        case .pass:                     return UIImage(named: "license")
        case .medical:                  return UIImage(named: "medLicense")
        case .insurance:                return UIImage(named: "insuranse")
        case .carPasport:               return UIImage(named: "insuranse")
        case .techChek:                 return UIImage(named: "techDoc")
        case .unlisted:                 return nil
        }
    }
}
