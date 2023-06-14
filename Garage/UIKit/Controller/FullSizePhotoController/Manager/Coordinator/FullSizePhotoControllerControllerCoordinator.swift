//
//  FullSizePhotoControllerControllerCoordinator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 12.06.23.
//  
//

import UIKit

class FullSizePhotoControllerCoordinator {
    
    // - VC
    private unowned let vc: FullSizePhotoViewController
    
    // - Init
    init(vc: FullSizePhotoViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
