//
//  StatisticRecordsControllerLayoutManager.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 17.09.23.
//  
//

import UIKit
import SnapKit

final class MostFrequentOpeartionControllerLayoutManager {
    
    private unowned let vc: MostFrequentOpeartionViewController
    
    // - UI
    private(set) lazy var tableView: BasicTableView = {
        let table = BasicTableView()
        table.register(RecordCell.self)
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
    init(vc: MostFrequentOpeartionViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension MostFrequentOpeartionControllerLayoutManager {
    
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
