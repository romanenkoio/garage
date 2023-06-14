//
//  AppStyle.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//

import Foundation
import UIKit

enum AppStyle: String {
    case black
    case standartBlue
    case orange
    case darkBlue
    case mint
    case lightBlue
    
    init(rawValue: String) {
        switch rawValue {
        case AppStyle.black.rawValue:           self = .black
        case AppStyle.standartBlue.rawValue:    self = .standartBlue
        case AppStyle.orange.rawValue:          self = .orange
        case AppStyle.darkBlue.rawValue:        self = .darkBlue
        case AppStyle.mint.rawValue:            self = .mint
        case AppStyle.lightBlue.rawValue:       self = .lightBlue
        default:                                self = .standartBlue
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
    static let green = UIColor(hexString: "#C9837")
}
