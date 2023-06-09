//
//  DocumentsControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//  
//

import UIKit

enum DocumentsNavigationRoute: Routable {
    case createDocument
}

class DocumentsControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? DocumentsNavigationRoute {
            switch route {
            case .createDocument:
                let new = CreateDocumentViewController(vm: .init())
                vc.push(new)
            }
        } else {
            super.navigateTo(route)
        }
    }
}
