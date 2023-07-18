//
//  PastRecordsControllerLayoutManager.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.06.23.
//  
//

import UIKit
import SnapKit

final class PastRecordsControllerLayoutManager {
    
    private unowned let vc: PastRecordsViewController
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc
        )
        table.register(RecordCell.self)
        table.register(BasicTableCell<DateHeaderView>.self)
        table.table.separatorStyle = .none
        table.table.isScrollEnabled = false
        table.table.contentInset = UIEdgeInsets(top: 20)
        table.table.contentInsetAdjustmentBehavior = .scrollableAxes
        table.backgroundColor = AppColors.background
        return table
    }()
        
    // - Init
    init(vc: PastRecordsViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension PastRecordsControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.view.addSubview(table)
        vc.contentView.removeFromSuperview()
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
