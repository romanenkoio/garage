//
//  ParkingMapControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 24.07.23.
//  
//

import UIKit
import SnapKit

final class ParkingMapControllerLayoutManager {
    
    private unowned let vc: ParkingMapViewController
    
    // - Init
    init(vc: ParkingMapViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension ParkingMapControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        
    }
    
    private func makeConstraint() {
        
    }
    
}
