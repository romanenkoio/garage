//
//  FeatureRecordsControllerLayoutManager.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.06.23.
//  
//

import UIKit
import SnapKit

final class FeatureRecordsControllerLayoutManager {
    
    private unowned let vc: FeatureRecordsViewController
    
    // - Init
    init(vc: FeatureRecordsViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension FeatureRecordsControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        
    }
    
    private func makeConstraint() {
        
    }
    
}
