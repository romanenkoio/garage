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

extension UIViewController {
    
    func showLoader() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}),
                  !window.subviews.contains(where: {$0 is LoaderView})
            else { return }
            
            let loader = LoaderView()
            loader.frame = CGRect(
                x: window.frame.origin.x,
                y: window.frame.origin.y,
                width: window.frame.width,
                height: window.frame.height
            )
            window.addSubview(loader)
        }
    }
    
    func dismissLoader() {
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
            let loaderView = window?.subviews.first(where: {$0 is LoaderView}) as? LoaderView
            loaderView?.dismissLoader()
        }
    }
    
}
