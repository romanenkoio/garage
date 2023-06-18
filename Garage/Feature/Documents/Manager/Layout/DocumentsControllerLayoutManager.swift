//
//  DocumentsControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//  
//

import UIKit
import SnapKit

final class DocumentsControllerLayoutManager {
    
    private unowned let vc: DocumentsViewController
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(DocumentCell.self)
        table.table.separatorStyle = .none
        return table
    }()
    
    lazy var addButton = AlignedButton()

    // - Init
    init(vc: DocumentsViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension DocumentsControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
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
