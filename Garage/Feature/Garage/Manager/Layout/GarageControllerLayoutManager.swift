//
//  GarageControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import SnapKit

final class GarageControllerLayoutManager {
    private unowned let vc: GarageViewController
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(CarCell.self)
        table.table.separatorColor = .clear
        return table
    }()

    lazy var addButton = AlignedButton()
    
    // - Init
    init(vc: GarageViewController) {
        self.vc = vc
        configure()
    }
}

// MARK: -
// MARK: - Configure

fileprivate extension GarageControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.disableScrollView()
        vc.contentView.addSubview(table)
        vc.contentView.addSubview(addButton)
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(bottom: 32))
            make.top.equalTo(table.snp.bottom)
        }
    }
}
