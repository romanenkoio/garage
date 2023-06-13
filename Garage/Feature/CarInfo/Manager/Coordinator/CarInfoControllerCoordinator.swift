//
//  CarInfoControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit

class CarInfoControllerCoordinator {
    
    // - VC
    private unowned let vc: CarInfoViewController
    
    // - Init
    init(vc: CarInfoViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
