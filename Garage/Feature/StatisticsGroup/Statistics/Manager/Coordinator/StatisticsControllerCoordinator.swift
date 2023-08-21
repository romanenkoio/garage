//
//  StatisticsControllerCoordinator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.08.23.
//  
//

import UIKit

class StatisticsControllerCoordinator {
    
    // - VC
    private unowned let vc: StatisticsViewController
    
    // - Init
    init(vc: StatisticsViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
