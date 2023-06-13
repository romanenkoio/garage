//
//  TabBarController.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 19.05.23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    let dataSource = TabBarController.ViewModel.TabItem.allCases
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBar.tintColor = .primaryGreen
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.layer.borderWidth = 0.2
        tabBar.backgroundColor = UIColor(hexString: "#F9F9F9").withAlphaComponent(0.94)
        tabBar.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateTabBar()
    }
    
    func configurateTabBar() {
        var controllers: [UIViewController] = []
        
        dataSource.forEach { controller in
            controllers.append(controller.viewController)
        }
        
        viewControllers = controllers
        
        viewControllers?.enumerated().forEach({ index, controller in
            controller.tabBarItem = UITabBarItem(
                title: dataSource[index].rawValue,
                image: dataSource[index].iconImage,
                tag: dataSource[index].hashValue
            )
        })
    }
    
}

