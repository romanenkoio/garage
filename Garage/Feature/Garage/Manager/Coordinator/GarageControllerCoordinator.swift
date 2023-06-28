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
    case settings
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
                let new = CreateCarViewController(vm: .init(mode: .create))
                vc.push(new)
            case .openCar(let car):
                let new = CarInfoViewController(vm: .init(car: car))
                vc.push(new)
            case .settings:
                let new = SettingsViewController(vm: .init())
                vc.push(new)
            }
        } else {
            super.navigateTo(route)
        }
    }
}
