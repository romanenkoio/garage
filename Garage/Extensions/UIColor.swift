//
//  UIColor.swift
//  Logogo
//
//  Created by Illia Romanenko on 13.05.23.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    static public var additionalRed: UIColor {
        return .init(named: "additionalRed")!
    }
    
    static public var primaryGray: UIColor {
        return .init(named: "primaryGray")!
    }
    
    static public var primaryPink: UIColor {
        return .init(named: "primaryPink")!
    }
    
    static public var secondaryGray: UIColor {
        return .init(named: "secondaryGray")!
    }
    
    static public var secondaryPink: UIColor {
        return .init(named: "secondaryPink")!
    }
    
    static public var textBlack: UIColor {
        return .init(named: "textBlack")!
    }

    static public var textGray: UIColor {
        return .init(named: "textGray")!
    }
    
    static public var secondaryBlue: UIColor {
        return .init(named: "secondaryBlue")!
    }
    
    static public var textLightGray: UIColor {
        return .init(named: "textLightGray")!
    }
    
    static public var primaryBlue: UIColor {
        return .init(named: "primaryBlue")!
    }
}
