//
//  Uiview.swift
//  Logogo
//
//  Created by Illia Romanenko on 19.05.23.
//

import UIKit

extension UIView {
    enum Corners {
        case leftTop
        case rightBottom
        case rightTop
        case leftBottom

        var corner: CACornerMask  {
            switch self {
            case .leftTop:      return .layerMinXMinYCorner
            case .rightBottom:  return .layerMaxXMaxYCorner
            case .rightTop:     return .layerMaxXMinYCorner
            case .leftBottom:   return .layerMinXMaxYCorner
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 2, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 2, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
    
    func presentOnRootViewController(_ vc: UIViewController, animated: Bool) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController?.present(vc, animated: animated)
    }
}
