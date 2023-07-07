//
//  ValidationPattern.swift
//  Logogo
//
//  Created by Illia Romanenko on 25.05.23.
//

import Foundation

enum ValidationRule {
    case email
    case minimumLenght(Int)
    case maximumLenght(Int)
    case lenght(min: Int, max: Int)
    case onlyDigit
    case onlyLetter
    case password
    case noneEmpty
    case vin
    
    var pattern: String {
        switch self {
        case .email:                        return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .minimumLenght(let min):       return "^.{\(min)}$"
        case .maximumLenght(let max):       return "^.{1,\(max)}$"
        case .lenght(let min, let max):     return "^.{\(min),\(max)}$"
        case .onlyDigit:                    return "[0-9.]*"
        case .onlyLetter:                   return "[a-Z]*"
        case .password:                     return "[0-9a-zA-Z.@!&*^%$#@_]{6,20}"
        case .noneEmpty:                    return "^(?!\\s*$).+"
        case .vin:                          return "(?=.*\\d|[A-Z])(?=.*[A-Z])[A-Z0-9]{17}"
            
        }
    }
}
