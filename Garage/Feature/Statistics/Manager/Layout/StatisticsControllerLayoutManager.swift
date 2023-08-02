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
    
    let upTimer = Timer.publish(every: 0.0005, on: .main, in: .common).autoconnect()
    let downTimer = Timer.publish(every: 0.0005, on: .main, in: .common).autoconnect()
    
    var tableViewMinConstraintConstant: CGFloat = 0
    var animatedScrollConstraint: Constraint?
    var previousContentOffsetY: CGFloat = 0
    
    var newConstraintConstant: CGFloat = 0 {
        didSet {
            animatedScrollConstraint?.update(offset: newConstraintConstant)
            let carTopAnimationScale = max(1.0,min(-1.0 - newConstraintConstant / 200, 1))
            let carTopAlphaScale = min(max(1.0 - newConstraintConstant / 150, 0.0), 1.0)
            let contentViewCornerScale = max(newConstraintConstant / 9, 0)
            
            chartsView.transform = CGAffineTransform(scaleX: carTopAnimationScale, y: carTopAnimationScale)
            print(carTopAnimationScale)
            switch newConstraintConstant {
                case tableViewMinConstraintConstant-3...tableViewMinConstraintConstant+3:
                    upTimer.upstream.connect().cancel()
                case maxConstraintConstant!-3...maxConstraintConstant!+3:
                    downTimer.upstream.connect().cancel()
                default: break
            }
        }
    }
    
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
            animatedScrollConstraint = make.top.equalTo(vc.view.safeAreaLayoutGuide).offset(constant).constraint
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
