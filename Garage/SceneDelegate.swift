//
//  SceneDelegate.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else {
          return
        }
        
        guard let imported = Storage.retrieve(urlContext.url, as: Backup.self) else { return }
        Storage.remove(.backup, from: .documents)
        Storage.store(imported, to: .documents, as: .backup)
        imported.saveCurrent()
    }
}

