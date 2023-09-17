//
//  StatisticRecordsControllerCoordinator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 17.09.23.
//  
//

import UIKit
enum MostFrequentOpeartionNavigationRoute: Routable {
    case record(Car, Record)
}

class MostFrequentOpeartionControllerCoordinator: BasicCoordinator {
    
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? MostFrequentOpeartionNavigationRoute {
            switch route {
                case .record(let car, let record):
                    let controller = CreateRecordViewController(vm: .init(car: car, mode: .edit(object: record)))
                    vc.push(controller)
            }
        }
    }
    
}
