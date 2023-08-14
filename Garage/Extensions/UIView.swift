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
    
    func animateTap(_ completionBlock: @escaping Completion) {
        isUserInteractionEnabled = false
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveLinear,
            animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 1.10, y: 1.10)
            })
        { [weak self] done in
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                options: .curveLinear,
                animations: { [weak self] in
                    self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                }
            ) { [weak self] _ in
                self?.isUserInteractionEnabled = true
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                completionBlock()
            }
        }
    }
    
    func presentOnRootViewController(_ vc: UIViewController, animated: Bool) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController?.present(vc, animated: animated)
    }
    
    func showDialog(_ vc: UIViewController, animated: Bool = true) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        sceneDelegate?.window?.rootViewController?.present(vc)
    }
    
    func showDialog(_ vm: Dialog.ViewModel) {
        let dialog = Dialog(vm: vm)
        dialog.modalPresentationStyle = .overCurrentContext
        dialog.modalTransitionStyle = .crossDissolve
    }
    
    func dropShadow(
        color: UIColor,
        shadowOffset: CGSize = CGSize(width: 1, height: 1),
        shadowRadius: CGFloat = 3,
        shadowOpacity: Float
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}
