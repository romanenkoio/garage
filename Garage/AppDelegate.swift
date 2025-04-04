//
//  AppDelegate.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import Qonversion
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initNavbar()
        initPushes()
        initSystem()
        initLocalization()
        initMap()
        initQonversion()

        return true
    }

    private func initLocalization() {
        Bundle.setLocalization()
    }

    private func initMap() {
        GMSServices.provideAPIKey("AIzaSyAS6qgX2yi3HcDVg_Um0ScpBP4wkp3R5pM")
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
    
    private func initQonversion() {
        let config = Qonversion.Configuration(projectKey: "0YQ7SevbfZU8mpYc3OFQOwL_UAcXpw1H", launchMode: .subscriptionManagement)
        Qonversion.initWithConfig(config)
        QounversionPaidSubscriptionManager().getOfferings { result in
            switch result {
            case .success(let success):
                Environment.avaliblePlans = success
            case .failure:
                print("[SUBSCRIPTIONS]: Subs not avalible")
            }
        }
        
        QounversionPaidSubscriptionManager().subscriptionStatus { result in
            switch result {
            case .success(let subscription):
                switch subscription?.status {
                case .active:
                    Environment.isPrem = true
                case .inactive, .none:
                    Environment.isPrem = false
                }
                
            case .failure(_):
                Environment.isPrem = false
            }
        }
    }
}

