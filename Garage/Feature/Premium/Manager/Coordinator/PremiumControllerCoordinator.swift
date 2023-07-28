//
//  PremiumControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//  
//

import UIKit

class PremiumControllerCoordinator {
    
    // - VC
    private unowned let vc: PremiumViewController
    
    // - Init
    init(vc: PremiumViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
