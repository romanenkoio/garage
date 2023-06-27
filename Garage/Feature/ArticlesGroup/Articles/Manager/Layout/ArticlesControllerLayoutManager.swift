//
//  ArticlesControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 27.06.23.
//  
//

import UIKit
import SnapKit

final class ArticlesControllerLayoutManager {
    
    private unowned let vc: ArticlesViewController
    
    lazy var table: BasicTableView = {
       let table = BasicTableView()
        table.setupTable(dataSource: vc, delegate: vc)
        table.register(BasicTableCell<ArticleView>.self)
        table.table.separatorStyle = .none
        table.table.contentInset = .init(top: 15)
        return table
    }()
    
    // - Init
    init(vc: ArticlesViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension ArticlesControllerLayoutManager {
    
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
            make.edges.equalToSuperview()
        }
    }
    
}
