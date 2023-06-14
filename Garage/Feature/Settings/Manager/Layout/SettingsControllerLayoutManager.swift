//
//  SettingsControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//  
//

import UIKit
import SnapKit

final class SettingsControllerLayoutManager {
    
    private unowned let vc: SettingsViewController
    
    // - Init
    init(vc: SettingsViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension SettingsControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        
    }
    
    private func makeConstraint() {
        
    }
    
}
