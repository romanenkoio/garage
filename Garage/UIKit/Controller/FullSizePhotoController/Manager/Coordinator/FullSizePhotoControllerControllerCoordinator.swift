//
//  FullSizePhotoControllerControllerCoordinator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 12.06.23.
//  
//

import UIKit

class FullSizePhotoControllerControllerCoordinator {
    
    // - VC
    private unowned let vc: FullSizePhotoControllerViewController
    
    // - Init
    init(vc: FullSizePhotoControllerViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
