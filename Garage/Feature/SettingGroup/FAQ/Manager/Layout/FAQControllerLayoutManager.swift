//
//  FAQControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 11.09.23.
//  
//

import UIKit
import SnapKit

final class FAQControllerLayoutManager {
    
    private unowned let vc: FAQViewController
    
    lazy var table: BasicTableView = {
        let table = BasicTableView(style: .insetGrouped)
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(BasicTableCell<FAQView>.self)
        
        let label = BasicLabel(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        label.text = "Информация приведена справочно. Для подробностей изучите эксплуатационное руководство вашего автомобиля."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineSpacing = 5
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = AppColors.tabbarIcon
        label.textInsets = .init(top: 15, horizontal: 16)

        table.table.tableHeaderView = label
        return table
    }()

    // - Init
    init(vc: FAQViewController) {
        self.vc = vc
        configure()
        vc.disableScrollView()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension FAQControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(table)
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
