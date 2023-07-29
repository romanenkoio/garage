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
    private(set) lazy var pieChart = PieChart()

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
        vc.contentView.addSubview(pieChart)
    }
    
    private func makeConstraint() {
        pieChart.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview().inset(UIEdgeInsets(top: 20))
        }
    }
    
}
