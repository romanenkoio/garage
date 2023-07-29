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
        vc.contentView.addSubview(barChart)
        vc.contentView.addSubview(pieChart)
    }
    
    private func makeConstraint() {
        barChart.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(UIEdgeInsets(top: 20))
        }
        
        pieChart.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(top: 20))
            make.top.equalTo(barChart.snp.bottom).offset(30)
        }
    }
    
}
