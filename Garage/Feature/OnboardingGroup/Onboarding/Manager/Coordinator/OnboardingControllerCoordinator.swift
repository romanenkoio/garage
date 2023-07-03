//
//  OnboardingControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 3.07.23.
//  
//

import UIKit

class OnboardingControllerCoordinator {
    
    // - VC
    private unowned let vc: OnboardingViewController
    
    // - Init
    init(vc: OnboardingViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
