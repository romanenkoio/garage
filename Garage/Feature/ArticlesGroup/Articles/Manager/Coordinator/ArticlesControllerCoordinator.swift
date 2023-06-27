//
//  ArticlesControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 27.06.23.
//  
//

import UIKit

enum ArticlesNavigationRoute: Routable {
    case openArticle(Article)
}

class ArticlesControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? ArticlesNavigationRoute {
            switch route {
            case .openArticle(let article):
                let new = ReadArticleViewController(vm: .init(article: article))
                vc.push(new)
            }
        } else {
            super.navigateTo(route)
        }
    }
}
