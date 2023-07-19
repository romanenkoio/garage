//
//  UIApplication.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import UIKit

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    var topController: BasicViewController? {
        var controller: UIViewController?
        
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            controller = topController
        }

        guard let controller = controller as? TabBarController,
              let topNC = controller.selectedViewController as? UINavigationController,
              let topVC = topNC.topViewController
        else { return nil }
        return topVC as? BasicViewController
      }
}
