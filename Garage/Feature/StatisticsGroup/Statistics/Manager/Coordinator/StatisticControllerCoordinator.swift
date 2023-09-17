//
//  StatisticsControllerCoordinator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.08.23.
//  
//

import UIKit
enum StatisticNavigationRoute: Routable {
    case allRecords(Car, String)
    case editRecord(Car, Record)
}

class StatisticControllerCoordinator: BasicCoordinator {

    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? StatisticNavigationRoute {
            switch route {
                case .allRecords(let car, let operationType):
                    let controller = MostFrequentOpeartionViewController(
                        vm: .init(
                            car: car,
                            operationType: operationType
                        )
                    )
                    vc.push(controller)
                    
                case .editRecord(let car, let record):
                    let controller = CreateRecordViewController(vm: .init(car: car, mode: .edit(object: record)))
                    vc.push(controller)
            }
        }
    }
    
}
