//
//  ConfirmPopupControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 23.06.23.
//  
//

import UIKit

class ConfirmPopupControllerCoordinator {
    
    // - VC
    private unowned let vc: ConfirmPopupViewController
    
    // - Init
    init(vc: ConfirmPopupViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
