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
        handleImport(by: urlContext.url)
    }
    
    private func handleImport(by ulr: URL) {
        guard let imported = Storage.retrieve(ulr, as: Backup.self),
              let topVC = UIApplication.shared.topController
        else { return }
   
        let popupVM = Dialog.ViewModel(
            title: .text("Вы действительно хотите импортировать данные?"),
            subtitle: .text("Все текущие записи будут удалены"),
            confirmTitle: "Импортировать",
            confirmColor: AppColors.green
        ) {
            topVC.showLoader()
            DispatchQueue.global().async {
                RealmManager().removeAll()
                Storage.remove(.backup, from: .documents)
                Storage.store(imported, to: .documents, as: .backup)
                imported.saveCurrent()
                topVC.dismissLoader()
            }
        }
        let popup = Dialog(vm: popupVM)
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        topVC.tabBarController?.present(popup)
    
    }
}

