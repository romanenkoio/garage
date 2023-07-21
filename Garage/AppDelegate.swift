//
//  AppDelegate.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit
import IQKeyboardManagerSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initNavbar()
        initPushes()
        initSystem()
        initLocalization()
        return true
    }

    private func initLocalization() {
        Bundle.swizzleLocalization()
    }

    private func initNavbar() {
        if #available(iOS 15.0, *) {
            let attrs = [
                NSAttributedString.Key.foregroundColor: AppColors.navbarTitle,
                NSAttributedString.Key.font: UIFont.custom(size: 16, weight: .bold)
            ]
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = .white
            navigationBarAppearance.titleTextAttributes = attrs
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
    
    private func initPushes() {
        Task {
            await PushManager.sh.checkPermission()
        }
    }
    
    private func initSystem() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        IQKeyboardManager.shared.enable = true
    }
}

