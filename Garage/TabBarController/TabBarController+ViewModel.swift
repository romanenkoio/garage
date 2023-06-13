//
//  TabBarController+ViewModel.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 19.05.23.
//

import UIKit

extension TabBarController {
    class ViewModel {
        enum TabItem: String, CaseIterable {
            case garage = "Гараж"
            case documents = "Документы"
            case services = "Сервисы"
            case settings = "Настройки"
            
            var viewController: UIViewController {
                switch self {
                case .garage:
                    return GarageViewController(vm: .init()).withNavigation()
                case .documents:
                    return DocumentsViewController(vm: .init()).withNavigation()
                case .services:
                    return ServicesViewController(vm: .init()).withNavigation()
                case .settings:
                    return BasicViewController()
                }
            }
            
            var iconImage: UIImage? {
                switch self {
                    case .garage:
                        return UIImage(named: "garage")
                    case .documents:
                        return UIImage(named: "documents")
                    case .services:
                        return UIImage(named: "services")
                    case .settings:
                        return UIImage(named: "settings")
                }
            }
        }
    }
}





