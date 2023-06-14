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
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        return table
    }()
    
    // - Init
    init(vc: SettingsViewController) {
        self.vc = vc
        configure()
        vc.disableScrollView()
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
        vc.contentView.addSubview(table)
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
