//
//  BasicCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit

class BasicCoordinator: Routable {
    
    unowned let vc: BasicViewController

    init(vc: BasicViewController) {
        self.vc = vc
    }
    
    func navigateTo(_ route: Routable) {
        guard let route = route as? CommonNavigationRoute else { return }
        
        switch route {
        case .close:
            self.vc.pop()
            self.vc.dismiss(animated: true)
        case .closeToRoot:
            vc.popToRoot()
        case .confirmPopup(vm: let vm):
            show(vm)
        case .share(let content):
            share(content)
        case .presentOnTop(let vc):
            self.vc.present(vc)
        case .premium:
            TabBarController.sh.showPremium()
        }
    }
    
    private func show(_ vm: Dialog.ViewModel) {
        let popup = ConfirmPopupViewController(vm: vm)
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        vc.present(popup)
    }
    
    private func share(_ content: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: content, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.vc.view
        vc.present(activityViewController, animated: true, completion: nil)
    }
}

class BasicModalCoordinator: BasicCoordinator {
    unowned let modalVC: BasicModalPresentationController

    init(modalVC: BasicModalPresentationController) {
        self.modalVC = modalVC
        super.init(vc: BasicViewController())
    }
    
    override func navigateTo(_ route: Routable) {
        guard let route = route as? CommonNavigationRoute else { return }
        
        switch route {
        case .close:
            self.modalVC.pop()
        case .closeToRoot:
            modalVC.popToRoot()
        case .confirmPopup:
           break
        case .share:
            break
        case .presentOnTop:
            break
        case .premium:
            break
        }
    }
}
