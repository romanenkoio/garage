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
        guard let imported = Storage.retrieve(ulr, as: Backup.self) else { return }
        var controller: UIViewController?
        
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            controller = topController
        }

        guard let controller = controller as? TabBarController,
              let topNC = controller.selectedViewController as? UINavigationController,
              let topVC = topNC.topViewController as? BasicViewController
        else { return }
        
        let popupVM = Popup.ViewModel(titleVM: .init(.text("Вы действительно хотите импортировать данные? Текущие записи будут удалены")))
        popupVM.confirmButton.title = "Импортировать"
        let popup = Popup(vm: popupVM)

        popupVM.confirmButton.action = .touchUpInside {
            popup.close()
            topVC.startLoader()
            DispatchQueue.global().async {
                RealmManager().removeAll()
                Storage.remove(.backup, from: .documents)
                Storage.store(imported, to: .documents, as: .backup)
                imported.saveCurrent()
                DispatchQueue.main.async {
                    topVC.stopLoader()
                }
            }
            
        }
        
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        topVC.present(popup)
    
    }
}

