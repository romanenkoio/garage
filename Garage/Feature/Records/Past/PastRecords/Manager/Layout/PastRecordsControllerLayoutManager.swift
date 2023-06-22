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
//        vc.contentView.addSubview(addButton)
        vc.contentView.isHidden = true
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
//        addButton.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.top.equalTo(table.snp.bottom).offset(-16)
//        }
    }
    
}
