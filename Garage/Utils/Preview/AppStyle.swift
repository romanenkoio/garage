//
//  AppStyle.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//

import Foundation

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
}
