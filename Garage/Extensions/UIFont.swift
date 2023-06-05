//
//  UIFont.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 17.05.23.
//

import UIKit

enum FontWeight {
    case thin
    case light
    case ultralight
    case medium
    case bold
    case semibold
    case heavy
    case black
}

extension UIFont {
    static func custom(size: CGFloat, weight: FontWeight) -> UIFont {
        switch weight {
            case .thin:             return UIFont(name: "SFUIDisplay-Thin", size: size) ?? .systemFont(ofSize: size)
            case .light:            return UIFont(name: "SFUIDisplay-Light", size: size) ?? .systemFont(ofSize: size)
            case .ultralight:       return UIFont(name: "SFUIDisplay-Ultralight", size: size) ?? .systemFont(ofSize: size)
            case .medium:           return UIFont(name: "SFUIDisplay-Medium", size: size) ?? .systemFont(ofSize: size)
            case .bold:             return UIFont(name: "SFUIDisplay-Bold", size: size) ?? .systemFont(ofSize: size)
            case .semibold:         return UIFont(name: "SFUIDisplay-Semibold", size: size) ?? .systemFont(ofSize: size)
            case .heavy:            return UIFont(name: "SFUIDisplay-Heavy", size: size) ?? .systemFont(ofSize: size)
            case .black:            return UIFont(name: "SFUIDisplay-Black", size: size) ?? .systemFont(ofSize: size)
        }
    }
}

