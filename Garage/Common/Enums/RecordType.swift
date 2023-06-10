//
//  RecordType.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import Foundation

enum RecordType: Equatable, CaseIterable {
    case paste
    case future
    
    var title: String {
        switch self {
        case .paste:    return "История"
        case .future:   return "Запланированное"
        }
    }
}
