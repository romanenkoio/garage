//
//  CreateRecordControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 15.06.23.
//  
//

import UIKit

class CreateRecordControllerCoordinator {
    
    // - VC
    private unowned let vc: CreateRecordViewController
    
    // - Init
    init(vc: CreateRecordViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
