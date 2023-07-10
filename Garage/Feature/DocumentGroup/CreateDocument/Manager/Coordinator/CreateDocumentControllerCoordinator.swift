//
//  CreateDocumentControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//  
//

import UIKit

enum CreateDocumentNavigationRoute: Routable {
    case selectSuggestion(SelectionViewController.ViewModel)
}

class CreateDocumentControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    deinit {
        print("deinit CreateDocumentControllerCoordinator")
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? CreateDocumentNavigationRoute {
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
