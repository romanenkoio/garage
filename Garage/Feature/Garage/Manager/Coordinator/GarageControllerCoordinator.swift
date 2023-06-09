//
//  GarageControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

enum GarageNavigationRoute: Routable {
    case createCar
    case openCar(Car)
}

class GarageControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? GarageNavigationRoute {
            switch route {
            case .createCar:
                let new = CreateCarViewController(vm: .init())
                vc.push(new)
            case .openCar:
                let new = BasicViewController()
                vc.push(new)
            }
        } else {
            super.navigateTo(route)
        }
    }
}
