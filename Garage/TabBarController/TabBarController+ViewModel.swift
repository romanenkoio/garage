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
            case studios = "Гараж"
            case favorite = "Напоминания"
            case booking = "Сервисы"
            case profile = "Настройки"
            
            var viewController: UIViewController {
                switch self {
                case .studios:
                    return GarageViewController(vm: .init()).withNavigation()
                case .favorite:
                    return BasicViewController()
                case .booking:
                    return BasicViewController()
                case .profile:
                    return ServicesViewController(vm: .init()).withNavigation()
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
        }
    }
}





