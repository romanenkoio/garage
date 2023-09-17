//
//  StatisticsControllerCoordinator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.08.23.
//  
//

import UIKit
enum StatisticNavigationRoute: Routable {
    case allRecords(Car)
    case editRecord(Car, Record)
}

class StatisticsControllerCoordinator: BasicCoordinator {

    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? StatisticNavigationRoute {
            switch route {
                case .allRecords(let car):
//                    let controller =
                    break
                case .editRecord(let car, let record):
                    let controller = CreateRecordViewController(vm: .init(car: car, mode: .edit(object: record)))
                    vc.push(controller)
            }
        }
    }
    
}
