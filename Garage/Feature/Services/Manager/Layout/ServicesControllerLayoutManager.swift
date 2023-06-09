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
    
    private unowned let vc: ServicesViewController
    
    lazy var categoriesStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.paddingInsets = .horizintal
        return stack
    }()
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(ServiceCell.self)
        return table
    }()
    
    // - Init
    init(vc: ServicesViewController) {
        self.vc = vc
        configure()
        
        let addButtonVM = NavBarButton.ViewModel(
            action: .touchUpInside {
                vc.coordinator.navigateTo(ServiceNavigationRoute.createService)
            },
            image: UIImage(systemName: "plus")
        )
        vc.makeRightNavBarButton(buttons: [addButtonVM])
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
        vc.contentView.addSubview(categoriesStack)
        vc.contentView.addSubview(table)
    }
    
    private func makeConstraint() {
        categoriesStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(40)
        }
        
        table.snp.makeConstraints { make in
            make.top.equalTo(categoriesStack.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
