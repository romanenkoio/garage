//
//  BasicBarChart.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.07.23.
//

import Foundation
import DGCharts
import UIKit

class BasicBarChart: BasicView {
    lazy var descriptionLabel: BasicLabel = {
        let view = BasicLabel()
        view.textAlignment = .left
        view.font = .custom(size: 24, weight: .bold)
        return view
    }()
    
    var barChartView = BarChartView()
    
    override init() {
        super.init()
        barChartView.delegate = self
        makeLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(barChartView)
        addSubview(descriptionLabel)
    }
    
    private func makeConstraints() {
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview()
        }
        
        let screenWidth = UIScreen.main.bounds.width
        barChartView.snp.makeConstraints { make in
            make.height.equalTo(screenWidth)
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {

        barChartView.highlightFullBarEnabled = true

        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: DateFormatter().shortMonthSymbols)
        descriptionLabel.setViewModel(vm.descriptionLabelVM)
        
    }
}

extension BasicBarChart: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
}
