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
    }
    
    func configurateTabBar() {        
        viewControllers = dataSource.map({ $0.viewController })
        
        viewControllers?.enumerated().forEach({ index, controller in
            controller.tabBarItem = UITabBarItem(
                title: dataSource[index].rawValue,
                image: dataSource[index].iconImage,
                tag: dataSource[index].hashValue
            )
        })
    }
    
}

