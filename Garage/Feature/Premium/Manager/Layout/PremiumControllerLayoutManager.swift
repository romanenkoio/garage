//
//  PremiumControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//  
//

import UIKit
import SnapKit

final class PremiumControllerLayoutManager {
    
    private unowned let vc: PremiumViewController
    
    // - Init
    init(vc: PremiumViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension PremiumControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        
    }
    
    private func makeConstraint() {
        
    }
    
}
