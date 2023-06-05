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
            case studios = "Ближайшие"
            case favorite = "Клиенты"
            case booking = "Расписание"
            case profile = "Профиль"
            
            var viewController: UIViewController {
                switch self {
                    case .studios:
                        return BasicViewController()
                    case .favorite:
                        return BasicViewController()
                    case .booking:
                        return BasicViewController()
                    case .profile:
                        return BasicViewController()
                }
            }
            
            var iconImage: UIImage {
                switch self {
                    case .studios:
                        return UIImage(systemName: "mappin.circle")!
                    case .favorite:
                        return UIImage(systemName: "heart.circle")!
                    case .booking:
                        return UIImage(systemName: "calendar.circle")!
                    case .profile:
                        return UIImage(systemName: "person.circle")!
                }
            }
            
            private func wrappedInNavigationController(with: UIViewController) -> UINavigationController {
                UINavigationController(rootViewController: with)
            }
        }
    }
}





