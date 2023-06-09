//
//  CreateRepairControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 10.06.23.
//  
//

import UIKit
import SnapKit

final class CreateRepairControllerLayoutManager {
    
    private unowned let vc: CreateRepairViewController
    
    // - Init
    init(vc: CreateRepairViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CreateRepairControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        
    }
    
    private func makeConstraint() {
        
    }
    
}
