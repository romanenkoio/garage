//
//  CreateCarControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

enum CreateCarNavigationRoute: Routable {
    case selectSuggestion(SelectionViewController.ViewModel)
}

class CreateCarControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? CreateCarNavigationRoute {
            switch route {
            case .selectSuggestion(let vm):
                let selectionVC = SelectionViewController(vm: vm)
                vc.present(selectionVC)
            }
        } else {
            super.navigateTo(route)
        }
    }
}
