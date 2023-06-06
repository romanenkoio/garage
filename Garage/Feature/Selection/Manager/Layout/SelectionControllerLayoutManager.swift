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
    
    lazy var table: UITableView = {
        let table = UITableView()
        return table
    }()
    
    lazy var saveButton = BasicButton()
    
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
        vc.contentView.addSubview(table)
        vc.contentView.addSubview(saveButton)
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(table.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
