//
//  UIViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit

extension UIViewController {
    func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func push(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func present(_ vc: UIViewController) {
        self.present(vc, animated: true)
    }
    
    func withNavigation() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
