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
    
    private(set) lazy var barChart = BarChart()
    
    private(set) lazy var yearBarStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.spacing = 5
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.edgeInsets = UIEdgeInsets(horizontal: 16)
        return stack
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
        vc.contentView.addSubview(barChart)
        vc.contentView.addSubview(yearBarStack)
    }
    
    private func makeConstraint() {
        barChart.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(UIEdgeInsets(top: 20))
        }
        
        yearBarStack.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(barChart.snp.bottom)
        }
    }
    
}
