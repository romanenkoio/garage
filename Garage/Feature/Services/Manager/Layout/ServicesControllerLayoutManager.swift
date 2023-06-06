//
//  ServicesControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import SnapKit

final class ServicesControllerLayoutManager {
    
    private unowned let vc: ServicesViewController
    
    lazy var categoriesStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.paddingInsets = .horizintal
        return stack
    }()
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    // - Init
    init(vc: ServicesViewController) {
        self.vc = vc
        configure()
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
        
        for i in 0...7 {
            let view = SuggestionView()
            view.setViewModel(.init(labelVM: .init(
                text: "Категория \(i)",
                action: {
                    print("Категория \(i)")
                }
            )))
            categoriesStack.addArrangedSubview(view)
        }
    }
    
    private func makeConstraint() {
        categoriesStack.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
}
