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
        window?.rootViewController = TestController(vm: TestController.ViewModel())
        window?.makeKeyAndVisible()
    }
}

