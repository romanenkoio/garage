//
//  CreateCarControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

enum CreateCarNavigationRoute: Routable {
    case selectBrand
    case selectModel
}

class CreateCarControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? CreateCarNavigationRoute {
            switch route {
            case .selectBrand:
                print("selectBrand")
                
            case .selectModel:
                print("selectBrand")
            }
        } else {
            super.navigateTo(route)
        }
    }
}
