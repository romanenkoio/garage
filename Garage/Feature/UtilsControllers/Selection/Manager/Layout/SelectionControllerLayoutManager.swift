//
//  SelectionControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import SnapKit

final class SelectionControllerLayoutManager {
    
    private unowned let vc: SelectionViewController
    
    lazy var searchField: BasicSearchField = {
        let field = BasicSearchField()
        return field
    }()
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(SelectCell.self)
        return table
    }()
    
    lazy var saveButton = AlignedButton()
    
    // - Init
    init(vc: SelectionViewController) {
        self.vc = vc
        configure()
        vc.disableScrollView()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension SelectionControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(searchField)
        vc.contentView.addSubview(table)
        vc.contentView.addSubview(saveButton)
    }
    
    private func makeConstraint() {
        searchField.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(UIEdgeInsets.init(top: 20, horizontal: 20))
        }
        
        table.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchField.snp.bottom)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(table.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets.horizintal)
        }
    }
    
}
