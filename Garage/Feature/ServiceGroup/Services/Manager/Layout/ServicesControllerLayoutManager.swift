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
    
    lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        return stack
    }()

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
        table.table.contentInset = .init(top: 20)
        return table
    }()
    
    lazy var addButton = FloatingButtonView()
    
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
        vc.contentView.addSubview(stack)
        vc.contentView.addSubview(table)
        vc.view.addSubview(addButton)
        stack.addArrangedSubviews([categoriesStack])
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        table.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(horizontal: 20))
            make.top.equalTo(stack.snp.bottom)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-105)
        }
    }
    
}
