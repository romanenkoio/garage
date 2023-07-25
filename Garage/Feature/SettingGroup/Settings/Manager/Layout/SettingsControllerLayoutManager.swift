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
        let table = BasicTableView(style: .insetGrouped)
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(BasicTableCell<SettingView>.self)
        table.register(BasicTableCell<PremiumView>.self)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.text = "Версия".localized(Bundle.main.version)
        label.textAlignment = .center
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = AppColors.tabbarIcon

        table.table.tableFooterView = label
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
