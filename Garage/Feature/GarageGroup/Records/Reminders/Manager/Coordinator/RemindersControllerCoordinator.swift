//
//  RemindersControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 5.07.23.
//  
//

import UIKit

class RemindersControllerCoordinator {
    
    // - VC
    private unowned let vc: RemindersViewController
    
    // - Init
    init(vc: RemindersViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
