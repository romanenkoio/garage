//
//  RemindersControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 5.07.23.
//  
//

import UIKit
import SnapKit

final class RemindersControllerLayoutManager {
    
    private unowned let vc: RemindersViewController
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(RecordCell.self)
        table.table.separatorStyle = .none
        table.table.isScrollEnabled = false
        table.table.contentInset = UIEdgeInsets(top: 20)
        table.table.contentInsetAdjustmentBehavior = .scrollableAxes
        table.backgroundColor = AppColors.background
        return table
    }()

    // - Init
    init(vc: RemindersViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension RemindersControllerLayoutManager {
    
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
