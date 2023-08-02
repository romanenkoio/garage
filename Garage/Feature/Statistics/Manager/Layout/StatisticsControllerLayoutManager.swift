//
//  StatisticsControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//  
//

import UIKit
import SnapKit

final class StatisticsControllerLayoutManager {
    
    private unowned let vc: StatisticsViewController
    
    private(set) var isFirstLayoutSubviews = true
    
    var maxConstraintConstant: CGFloat? {
        didSet {
            if isFirstLayoutSubviews {
                tableViewMinConstraintConstant = maxConstraintConstant! / 2
                makeConstraintsAfterLayout(with: maxConstraintConstant!)
                vc.view.layoutIfNeeded()
                isFirstLayoutSubviews = false
            }
        }
    }
    
    var tableViewMinConstraintConstant: CGFloat = 0
    var animatedScrollConstraint: Constraint?
    var previousContentOffsetY: CGFloat = 0
    
    private(set) lazy var chartsView = ChartsView()
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(RecordCell.self)
        table.register(BasicTableCell<DateHeaderView>.self)
        table.table.separatorStyle = .none
        table.table.contentInsetAdjustmentBehavior = .scrollableAxes
        table.backgroundColor = AppColors.background
        return table
    }()
    
    // - Init
    init(vc: StatisticsViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension StatisticsControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.view.addSubview(chartsView)
    }
    
    private func makeConstraint() {
        chartsView.snp.makeConstraints { make in
            make.top.equalTo(vc.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func makeConstraintsAfterLayout(with constant: CGFloat) {
        vc.contentView.addSubview(table)
        
        vc.contentView.snp.remakeConstraints { make in
            animatedScrollConstraint = make.top.equalTo(vc.view.safeAreaLayoutGuide).offset(constant).constraint
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
