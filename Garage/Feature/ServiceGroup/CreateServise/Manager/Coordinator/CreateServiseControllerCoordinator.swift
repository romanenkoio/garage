//
//  CreateServiseControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//  
//

import UIKit

enum CreateServiseNavigationRoute: Routable {
    case readServiceCamera(QrServiceReaderViewController.ViewModel)
    case readServicePhoto
}

class CreateServiseControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? CreateServiseNavigationRoute {
            switch route {
            case .readServiceCamera(let vm):
                let new = QrServiceReaderViewController(vm: vm)
                vc.present(new)
            case .readServicePhoto:
                break
            }
        } else {
            super.navigateTo(route)
        }
    }
}
