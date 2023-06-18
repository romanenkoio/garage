//
//  ServicesControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

enum ServiceNavigationRoute: Routable {
    case createService
    case editService(Service)
}

class ServicesControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? ServiceNavigationRoute {
            switch route {
            case .createService:
                let new = CreateServiseViewController(vm: .init(mode: .create))
                vc.push(new)
            case .editService(let service):
                let new = CreateServiseViewController(vm: .init(mode: .edit(object: service)))
                vc.push(new)
            }
        } else {
            super.navigateTo(route)
        }
    }
}
