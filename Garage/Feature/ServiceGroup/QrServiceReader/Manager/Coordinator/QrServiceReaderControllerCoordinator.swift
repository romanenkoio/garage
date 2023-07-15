//
//  QrServiceReaderControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 15.07.23.
//  
//

import UIKit

class QrServiceReaderControllerCoordinator {
    
    // - VC
    private unowned let vc: QrServiceReaderViewController
    
    // - Init
    init(vc: QrServiceReaderViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
