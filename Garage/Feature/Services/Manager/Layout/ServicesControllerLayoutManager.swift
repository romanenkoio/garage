//
//  ServicesControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import SnapKit
import SwiftUI

final class ServicesControllerLayoutManager {
    
    unowned let vc: ServicesViewController
    
    lazy var categoriesStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.paddingInsets = .horizintal
        stack.edgeInsets = .init(top: 26, bottom: 19)
        return stack
    }()
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(ServiceCell.self)
        table.table.separatorStyle = .none
        ////////////
        return table
    }()
    
    lazy var addButton = AlignedButton()
    
    // - Init
    init(vc: ServicesViewController) {
        self.vc = vc
        configure()
    }
    
    func hideCategoriesStack(_ suggestions: [SuggestionView.ViewModel]) {
        categoriesStack.clearArrangedSubviews()
        categoriesStack.isHidden = suggestions.isEmpty
        let views = suggestions.map({
            let view = SuggestionView()
            view.setViewModel($0)
            return view
        })
        categoriesStack.addArrangedSubviews(views)
    }
}

// MARK: -
// MARK: - Configure

fileprivate extension ServicesControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
//        vc.contentView.addSubview(categoriesStack)
        vc.view.addSubview(table)
//        vc.contentView.addSubview(addButton)
        vc.contentView.isHidden = true
    }
    
    private func makeConstraint() {
//        categoriesStack.snp.makeConstraints { make in
//            make.leading.trailing.top.equalToSuperview()
//        }
        
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        addButton.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.top.equalTo(table.snp.bottom)
//        }
    }
    
}
