//
//  BackupControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 16.07.23.
//  
//

import UIKit
import SnapKit

final class BackupControllerLayoutManager {
    
    private unowned let vc: BackupViewController
    
    lazy var table: BasicTableView = {
        let table = BasicTableView(style: .insetGrouped)
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(BasicTableCell<SettingView>.self)
        return table
    }()

    // - Init
    init(vc: BackupViewController) {
        self.vc = vc
        configure()
        vc.disableScrollView()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension BackupControllerLayoutManager {
    
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
