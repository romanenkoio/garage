//
//  StatisticsControllerLayoutManager.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.08.23.
//  
//

import UIKit
import SnapKit

final class StatisticsControllerLayoutManager {
    
    private unowned let vc: StatisticsViewController
    
    private(set) lazy var tableView: BasicTableView = {
        let table = BasicTableView()
        table.register(StatisticCell.self)
        table.register(BasicTableCell<DateHeaderView>.self)
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.backgroundColor = AppColors.background
        table.table.separatorStyle = .none
        return table
    }()
    
    // - Init
    init(vc: StatisticsViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension StatisticsControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(tableView)
    }
    
    private func makeConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
