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
            dataSource: vc,
            delegate: vc
        )
        table.register(RecordCell.self)
        table.table.separatorStyle = .none
        table.table.bounces = true
        table.table.alwaysBounceVertical = true
        table.table.isScrollEnabled = false
        return table
    }()
    
    lazy var addButton = AlignedButton()
    
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
//        vc.contentView.addSubview(addButton)
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(500)
        }
    }
}
