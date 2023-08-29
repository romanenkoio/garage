//
//  MainControllerCoordinator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 28.08.23.
//  
//

import UIKit

class StatisticPagesControllerCoordinator {
    
    // - VC
    private unowned let vc: StatisticPagesViewController
    
    // - Init
    init(vc: StatisticPagesViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
