//
//  FAQControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 11.09.23.
//  
//

import UIKit
import SnapKit

final class FAQControllerLayoutManager {
    
    private unowned let vc: FAQViewController
    
    // - Init
    init(vc: FAQViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension FAQControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        
    }
    
    private func makeConstraint() {
        
    }
    
}
