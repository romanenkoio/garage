//
//  PastRecordsControllerCoordinator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.06.23.
//  
//

import UIKit

enum PastRecordsNavigationRoute: Routable {
    case createPastRecord(Car)
    case editPastRecord(Car, Record)
}

class PastRecordsControllerCoordinator: BasicCoordinator {
    
    // - VC
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? PastRecordsNavigationRoute {
            switch route {
                case .createPastRecord(let car):
                    let new = CreateRecordViewController(
                        vm: .init(
                            car: car,
                            mode: .create
                        ))
                    vc.push(new)
                case .editPastRecord(let car, let record):
                    let edit = CreateRecordViewController(
                        vm: .init(
                            car: car,
                            mode: .edit(object: record)
                        ))
                vc.push(edit)
            }
        } else {
            super.navigateTo(route)
        }
    }
    
}
