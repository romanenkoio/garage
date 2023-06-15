//
//  CarInfoControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit

enum CarInfoNavigationRoute: Routable {
    case createRecord(Car)
    case edit(Car)
}

class CarInfoControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? CarInfoNavigationRoute {
            switch route {
            case .createRecord(let car):
                let controller = CreateRecordViewController(vm: .init(car: car))
                vc.push(controller)
            case .edit(let car):
                break
            }
        } else {
            super.navigateTo(route)
        }
    }
}
