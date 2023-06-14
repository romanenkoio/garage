//
//  SettingsControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//  
//

import UIKit

class SettingsControllerCoordinator {
    
    // - VC
    private unowned let vc: SettingsViewController
    
    // - Init
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
