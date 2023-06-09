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
          var viewController = self.keyWindow?.rootViewController
          
          if let presentedController = viewController as? UITabBarController {
              viewController = presentedController.selectedViewController
          }
          
          while let presentedController = viewController?.presentedViewController {
              if let presentedController = presentedController as? UITabBarController {
                  viewController = presentedController.selectedViewController
              } else {
                  viewController = presentedController
              }
          }
          
          return viewController as? BasicViewController
      }
}
