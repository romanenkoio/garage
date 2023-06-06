//
//  SelectionControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

class SelectionControllerCoordinator {
    
    // - VC
    private unowned let vc: SelectionViewController
    
    // - Init
    init(vc: SelectionViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
