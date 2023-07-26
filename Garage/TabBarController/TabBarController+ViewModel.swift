//
//  TabBarController+ViewModel.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 19.05.23.
//

import UIKit

extension TabBarController {
    class ViewModel {
        enum TabItem:  CaseIterable {
            case garage
            case documents
            case services
            case articles
            
            var viewController: UIViewController {
                switch self {
                case .garage:
                    return GarageViewController(vm: .init()).withNavigation()
                case .documents:
                    return DocumentsViewController(vm: .init()).withNavigation()
                case .services:
                    return ServicesViewController(vm: .init()).withNavigation()
                case .articles:
                    return ArticlesViewController(vm: .init()).withNavigation()
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
                    case .articles:
                        return UIImage(named: "articles")
                }
            }
            
            var title: String {
                switch self {
                case .garage:    return "Гараж".localized
                case .documents: return "Документы".localized
                case .services:  return "Сервисы".localized
                case .articles:  return "Статьи".localized
                }
            }
        }
    }
}





