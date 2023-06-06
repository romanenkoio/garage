//
//  ServicesControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

class ServicesControllerCoordinator {
    
    // - VC
    private unowned let vc: ServicesViewController
    
    // - Init
    init(vc: ServicesViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
