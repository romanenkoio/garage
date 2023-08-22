//
//  StatisticsControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//  
//

import UIKit

enum ChartsNavigationRoute: Routable {
    case editRecord(Car, Record)
    case stat(Car)
}

class ChartsControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? ChartsNavigationRoute {
            switch route {
                case .editRecord(let car, let record):
                    let controller = CreateRecordViewController(vm: .init(car: car, mode: .edit(object: record)))
                    vc.push(controller)
                    
                case .stat(let car):
                    let controller = StatisticsViewController(vm: .init(car: car))
                    vc.push(controller)
            }
        } else {
            super.navigateTo(route)
        }
    }
}
