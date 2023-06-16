//
//  UIFont.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 17.05.23.
//

import UIKit

enum FontWeight {
    case ultraLightItalic
    case medium
    case lightItalic
    case thinItalic
    case heavyItalic
    case boldItalic
    case semiboldItalic
    case regularItalic
    case blackItalic
    case regular
    case ultraLight
    case black
    case extrabold
    case mediumItalic
    case light
    case thin
    case extraboldItalic
    case semibold
    case bold
    case heavy
}

extension UIFont {
    static func custom(size: CGFloat, weight: FontWeight) -> UIFont {
        switch weight {
            case .ultraLightItalic:             return UIFont(name: "Gilroy-UltraLightItalic", size: size) ?? .systemFont(ofSize: size)
            case .medium:            return UIFont(name: "Gilroy-Medium", size: size) ?? .systemFont(ofSize: size)
            case .lightItalic:       return UIFont(name: "Gilroy-LightItalic", size: size) ?? .systemFont(ofSize: size)
            case .thinItalic:           return UIFont(name: "Gilroy-ThinItalic", size: size) ?? .systemFont(ofSize: size)
            case .heavyItalic:             return UIFont(name: "Gilroy-HeavyItalic", size: size) ?? .systemFont(ofSize: size)
            case .boldItalic:         return UIFont(name: "Gilroy-BoldItalic", size: size) ?? .systemFont(ofSize: size)
            case .semiboldItalic:            return UIFont(name: "Gilroy-SemiboldItalic", size: size) ?? .systemFont(ofSize: size)
            case .regularItalic:            return UIFont(name: "Gilroy-RegularItalic", size: size) ?? .systemFont(ofSize: size)
            case .blackItalic:            return UIFont(name: "Gilroy-BlackItalic", size: size) ?? .systemFont(ofSize: size)
            case .regular:            return UIFont(name: "Gilroy-Regular", size: size) ?? .systemFont(ofSize: size)
            case .ultraLight:            return UIFont(name: "Gilroy-UltraLight", size: size) ?? .systemFont(ofSize: size)
            case .black:            return UIFont(name: "Gilroy-Black", size: size) ?? .systemFont(ofSize: size)
            case .extrabold:            return UIFont(name: "Gilroy-Extrabold", size: size) ?? .systemFont(ofSize: size)
            case .mediumItalic:            return UIFont(name: "Gilroy-MediumItalic", size: size) ?? .systemFont(ofSize: size)
            case .light:            return UIFont(name: "Gilroy-Light", size: size) ?? .systemFont(ofSize: size)
            case .thin:            return UIFont(name: "Gilroy-Thin", size: size) ?? .systemFont(ofSize: size)
            case .extraboldItalic:            return UIFont(name: "Gilroy-ExtraboldItalic", size: size) ?? .systemFont(ofSize: size)
            case .semibold:            return UIFont(name: "Gilroy-Semibold", size: size) ?? .systemFont(ofSize: size)
            case .bold:            return UIFont(name: "Gilroy-Bold", size: size) ?? .systemFont(ofSize: size)
            case .heavy:            return UIFont(name: "Gilroy-Heavy", size: size) ?? .systemFont(ofSize: size)
        }
    }
}

