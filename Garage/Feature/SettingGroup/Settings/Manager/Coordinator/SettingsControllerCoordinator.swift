//
//  SettingsControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//  
//

import UIKit

enum SettingsNavigationRoute: Routable {
    case backup([[DataSubSetting]])
    case faq
}

class SettingsControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? SettingsNavigationRoute {
            switch route {
            case .backup(let points):
                let new = BackupViewController(vm: .init(points: points))
                vc.push(new)
                
            case .faq:
                vc.push(FAQViewController(vm: .init()))
            }
        } else {
            super.navigateTo(route)
        }
    }
}
