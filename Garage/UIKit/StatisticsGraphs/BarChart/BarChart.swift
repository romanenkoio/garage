//
//  BasicBarChart.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.07.23.
//

import UIKit
import DGCharts
import SnapKit

class BarChart: BasicView {
    var viewModel: ViewModel?
    
    lazy var customMarkerView = CustomMarkerView(frame: .zero, for: .bar)
    
    lazy var descriptionLabel: BasicLabel = {
        let view = BasicLabel()
        view.textAlignment = .left
        view.font = .custom(size: 24, weight: .bold)
        view.textInsets = .init(bottom: 10, left: 16)
        return view
    }()
    
    private(set) lazy var barChartView: BarChartView = {
        let barChart = BarChartView()
        barChart.highlightFullBarEnabled = true
        barChart.doubleTapToZoomEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.drawBordersEnabled = false
        barChart.dragEnabled = false
        barChart.scaleXEnabled = false
        barChart.scaleYEnabled = false
        barChart.legend.enabled = false
        barChart.animate(xAxisDuration: 0.3, yAxisDuration: 0.4)
        barChart.setViewPortOffsets(left: 0, top: 40, right: 0, bottom: 16)
        
        let leftAxis = barChart.leftAxis
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.gridLineWidth = 1
        
        let rightAxis = barChart.rightAxis
        rightAxis.gridColor = AppColors.background
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false
        
        let xAxis = barChart.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false
        
        return barChart
    }()
    
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
        customMarkerView.chartView = barChartView
        barChartView.marker = customMarkerView
    }
    
    private func makeConstraints() {
        let screenWidth = UIScreen.main.bounds.width
        let chartHight = screenWidth - 70
        barChartView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
            make.height.equalTo(chartHight)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(20)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.viewModel = vm
        
    }

}

extension BarChart: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        viewModel?.records = RealmManager<Record>().read().filter({[weak self] record in
            guard let self,
                  let year = self.viewModel?.year else {
                if record.date.components.month == Int(entry.x + 1) {
                    return true
                }
                return false
            }
            
            if record.date.components.month == Int(entry.x + 1),
               record.date.components.year == year {
                return true
            } else {
                return false
            }
        })
    }
}
