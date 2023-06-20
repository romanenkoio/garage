//
//  FeatureRecordsControllerCoordinator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.06.23.
//  
//

import UIKit

class FeatureRecordsControllerCoordinator {
    
    // - VC
    private unowned let vc: FeatureRecordsViewController
    
    // - Init
    init(vc: FeatureRecordsViewController) {
        self.vc = vc
    }
    
    func popViewController(animated: Bool = true) {
        vc.navigationController?.popViewController(animated: animated)
    }
    
}
