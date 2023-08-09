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
    
    // - Property
    private unowned let vc: StatisticsViewController
    var previousContentOffsetY: CGFloat = 0
    var tableViewMinConstraintConstant: CGFloat = 0
    var animatedTableViewConstraint: Constraint?
    
    // - Flag
    private(set) var isFirstLayoutSubviews = true
    
    // - Animation properties
    let upTimer = Timer.publish(every: 0.0004, on: .main, in: .common).autoconnect()
    let downTimer = Timer.publish(every: 0.0004, on: .main, in: .common).autoconnect()
    
    var startChartsOrigin = CGPoint()
    
    var newConstraintConstant: CGFloat = 0 {
        didSet {
            animatedTableViewConstraint?.update(offset: newConstraintConstant)
            
            let tableViewCornerScale = max(newConstraintConstant / 22.5, 0)
            let chartAnimationScale = min(-startChartsOrigin.y + newConstraintConstant / 3.7, startChartsOrigin.y)
            
            chartsView.containerView.frame.origin.y = chartAnimationScale
            table.cornerRadius = tableViewCornerScale
            
            switch newConstraintConstant {
                case tableViewMinConstraintConstant-0.1...tableViewMinConstraintConstant+0.1:
                    upTimer.upstream.connect().cancel()
                case maxConstraintConstant!-1...maxConstraintConstant!+1:
                    downTimer.upstream.connect().cancel()
                default: break
            }
        }
    }
    
    var maxConstraintConstant: CGFloat? {
        didSet {
            tableViewMinConstraintConstant = maxConstraintConstant! / 2
            makeConstraintsAfterLayout(with: maxConstraintConstant!)
            vc.view.layoutIfNeeded()
            isFirstLayoutSubviews = false
        }
    }
    
    // - UIComponents
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
        table.cornerRadius = 20
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
        vc.view.addSubview(table)
    }
    
    private func makeConstraint() {
        chartsView.snp.makeConstraints { make in
            make.top.equalTo(vc.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func makeConstraintsAfterLayout(with constant: CGFloat) {
        vc.contentView.removeFromSuperview()
        table.snp.makeConstraints { make in
            animatedTableViewConstraint = make.top.equalTo(vc.view.safeAreaLayoutGuide).offset(constant).constraint
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
