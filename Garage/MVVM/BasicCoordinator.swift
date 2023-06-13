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
        case .closeToRoot:
            vc.popToRoot()
        }
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
        }
    }
}
