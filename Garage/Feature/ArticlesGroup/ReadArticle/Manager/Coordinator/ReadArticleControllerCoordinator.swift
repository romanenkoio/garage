//
//  ReadArticleControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 28.06.23.
//  
//

import UIKit

class ReadArticleControllerCoordinator {
    
    // - VC
    private unowned let vc: ReadArticleViewController
    
    // - Init
    init(vc: ReadArticleViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
