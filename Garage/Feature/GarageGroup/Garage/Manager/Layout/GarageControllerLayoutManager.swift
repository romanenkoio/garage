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
        table.register(AddCarCell.self)
        table.register(BannerCell.self)
        table.table.separatorColor = .clear

        return table
    }()

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
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, horizontal: 20))
        }
    }
}
