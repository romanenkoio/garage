//
//  AppStyle.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//

import Foundation
import UIKit

enum ColorScheme: String, CaseIterable {
    case black
    case standartBlue
    case orange
    case darkBlue
    case mint
    case lightBlue
    
    static var current: ColorScheme {
        return ColorScheme(rawValue: SettingsManager.sh.read(.colorSet))
    }
    
    init(rawValue: String) {
        switch rawValue {
        case ColorScheme.black.rawValue:           self = .black
        case ColorScheme.standartBlue.rawValue:    self = .standartBlue
        case ColorScheme.orange.rawValue:          self = .orange
        case ColorScheme.darkBlue.rawValue:        self = .darkBlue
        case ColorScheme.mint.rawValue:            self = .mint
        case ColorScheme.lightBlue.rawValue:       self = .lightBlue
        default:                                   self = .standartBlue
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .black:            return AppColors.black
        case .standartBlue:     return AppColors.standartBlue
        case .orange:           return AppColors.orange
        case .darkBlue:         return AppColors.darkBlue
        case .mint:             return AppColors.mint
        case .lightBlue:        return AppColors.lightBlue
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .black:            return AppColors.green
        case .standartBlue:     return AppColors.standartBlue
        case .orange:           return AppColors.black
        case .darkBlue:         return AppColors.darkBlue
        case .mint:             return AppColors.mint
        case .lightBlue:        return AppColors.mint
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .orange:           return AppColors.orange
        default:                return AppColors.black
        }
    }
}


struct AppColors {
    static let black = UIColor(hexString: "171717")
    static let standartBlue = UIColor(hexString: "2042E9")
    static let orange = UIColor(hexString: "F07300")
    static let darkBlue = UIColor(hexString: "0C1E92")
    static let mint = UIColor(hexString: "5FC8AB")
    static let lightBlue = UIColor(hexString: "2A5AD9")
    static let green = UIColor(hexString: "C9837")
    static let background = UIColor(hexString: "F6F6F6")
    static let error = UIColor(hexString: "E84949")
    static let lightGray = UIColor(hexString: "#D9D9D9")
    static let darkGray = UIColor(hexString: "#929292")
}
