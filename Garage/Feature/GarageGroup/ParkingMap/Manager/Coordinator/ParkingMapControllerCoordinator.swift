//
//  ParkingMapControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 24.07.23.
//  
//

import UIKit

class ParkingMapControllerCoordinator {
    
    // - VC
    private unowned let vc: ParkingMapViewController
    
    // - Init
    init(vc: ParkingMapViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
