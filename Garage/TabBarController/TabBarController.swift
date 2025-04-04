//
//  TabBarController.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 19.05.23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let dataSource: [TabBarController.ViewModel.TabItem] = [.garage, .documents, .services]
    
    static let sh = TabBarController()
    
    private init() {
        super.init(nibName: nil, bundle: nil)
        tabBar.tintColor = .primaryBlue
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.layer.borderWidth = 0.2
        tabBar.backgroundColor = AppColors.background.withAlphaComponent(0.94)
        tabBar.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateTabBar()
        setBadge()
    }
    
    func configurateTabBar() {
        viewControllers = dataSource.map({ $0.viewController })
        
        viewControllers?.enumerated().forEach({ index, controller in
            controller.tabBarItem = UITabBarItem(
                title: dataSource[index].title,
                image: dataSource[index].iconImage,
                tag: dataSource[index].hashValue
            )
        })
    }
    
    func setBadge() {
//        cars badge
        let cars: [Car] = RealmManager().read()
        var reminders: [Reminder] = .empty
        cars.forEach({ reminders += $0.reminders })
        let carBadge = reminders.filter({ $0.isOverdue.status == true })
        self.viewControllers?.first?.tabBarItem.badgeValue = carBadge.isEmpty ? nil : "\(carBadge.count)"
        
//        document badge
        let documents: [Document] = RealmManager().read()
        let documentsBadge = documents.filter({ $0.isOverdue.status == true })
        self.viewControllers?[safe: 1]?.tabBarItem.badgeValue = documentsBadge.isEmpty ? nil : "\(documentsBadge.count)"

        UIApplication.shared.applicationIconBadgeNumber = carBadge.count + documentsBadge.count
    }
    
    func showPremium() {
        let vc = PremiumViewController(vm: .init())
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc)
    }
}

