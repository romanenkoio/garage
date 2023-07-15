//
//  QrServiceReaderControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 15.07.23.
//  
//

import UIKit
import SnapKit

final class QrServiceReaderControllerLayoutManager {
    
    private unowned let vc: QrServiceReaderViewController
    
    // - Init
    init(vc: QrServiceReaderViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension QrServiceReaderControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        
    }
    
    private func makeConstraint() {
        
    }
    
}
