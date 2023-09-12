//
//  TextValue.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//

import Foundation

enum TextValue {
    case text(String)
    case attributed(NSMutableAttributedString)
    
    var clearText: String {
        switch self {
        case .text(let text):
            return text
        case .attributed(let text):
            return text.string
        }
    }
    
}
