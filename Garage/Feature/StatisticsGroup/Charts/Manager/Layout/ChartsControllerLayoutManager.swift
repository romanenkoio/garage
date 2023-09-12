//
//  StatisticsControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//  
//

import UIKit
import SnapKit

final class ChartsControllerLayoutManager {
    
    // - Property
    private unowned let vc: ChartsViewController
    var previousContentOffsetY: CGFloat = 0
    private(set) var animatedTableViewConstraint: Constraint?
    
    // - Flag
    private(set) var isFirstLayoutSubviews = true
    
    // - Animation properties
    private(set) var upAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
    private(set) var downAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
    var initialContentSizeHeight: CGFloat = 0
    var isAutoDragging: Bool = false
    var contentMovesUp = false
    var contentMovesDown = false
    var startChartsOrigin = CGPoint()
    var tableViewMinConstraintConstant: CGFloat = 0
    
    var newConstraintConstant: CGFloat = 0 {
        didSet {
            animatedTableViewConstraint?.update(offset: newConstraintConstant)
            
            if isAutoDragging {
                upAnimator.addAnimations {[weak self] in
                    guard let self else { return }
                    self.makeAutoAnimations(with: newConstraintConstant)
                }
                
                downAnimator.addAnimations {[weak self] in
                    guard let self else { return }
                    self.makeAutoAnimations(with: newConstraintConstant)
                    
                }
            } else {
                makeManualAnimations(with: newConstraintConstant)
            }
            
            switch newConstraintConstant {
                case 0:
                    if table.table.contentSize.height == vc.view.frame.height + 150 {
                        table.table.contentSize.height = initialContentSizeHeight
                    }
                    
                    upAnimator.stopAnimation(true)
                    
                case maxConstraintConstant!:
                    downAnimator.stopAnimation(true)
                    
                default:
                    if table.table.contentSize.height < vc.view.frame.height + 150 {
                        table.table.contentSize.height = vc.view.frame.height + 150
                    }
            }
        }
    }
    
    var maxConstraintConstant: CGFloat? {
        didSet {
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
        table.backgroundColor = AppColors.background
        return table
    }()
    
    private(set) lazy var yearBarStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.spacing = 5
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.contentInset = UIEdgeInsets(top: 10, bottom: 20, horizontal: 16)
        return stack
    }()
    
    private lazy var containerView: BasicView = {
        let view = BasicView()
        view.backgroundColor = AppColors.background
        table.cornerRadius = 20
        return view
    }()
    
    // - Init
    init(vc: ChartsViewController) {
        self.vc = vc
        configure()
    }


    
    private func makeAutoAnimations(with constant: CGFloat) {
        let offsetFromTableToCharts = 20.0
        let containerViewCornerScale = min(20,max(constant / 20, 0))
        let chartSizeConstant = (maxConstraintConstant! - offsetFromTableToCharts) / 70
        let chartAnimationScale = min(-70 + constant / chartSizeConstant, 0)
        
        self.vc.view.layoutIfNeeded()
        self.chartsView.containerView.frame.origin.y = chartAnimationScale
        self.containerView.cornerRadius = containerViewCornerScale
    }
    
    private func makeManualAnimations(with constant: CGFloat) {
        let offsetFromTableToCharts = 20.0
        let containerViewCornerScale = min(20,max(constant / 20, 0))
        let chartSizeConstant = (maxConstraintConstant! - offsetFromTableToCharts) / 70
        let chartAnimationScale = min(-70 + constant / chartSizeConstant, 0)
        
        self.chartsView.containerView.frame.origin.y = chartAnimationScale
        self.containerView.cornerRadius = containerViewCornerScale
        print(chartAnimationScale)
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension ChartsControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.view.addSubview(chartsView)
        vc.view.addSubview(containerView)
        containerView.addSubview(yearBarStack)
        containerView.addSubview(table)
    }
    
    private func makeConstraint() {
        chartsView.snp.makeConstraints { make in
            make.top.equalTo(vc.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func makeConstraintsAfterLayout(with constant: CGFloat) {
        vc.contentView.removeFromSuperview()
        
        yearBarStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(9)
        }
        
        table.snp.makeConstraints { make in
            make.top.equalTo(yearBarStack.snp.bottom).offset(-15)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            animatedTableViewConstraint = make.top.equalTo(vc.view.safeAreaLayoutGuide).offset(constant).constraint
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
