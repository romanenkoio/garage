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
    lazy var customMarkerView = CustomMarkerView(frame: .zero, for: .bar)
    
    lazy var descriptionLabel: BasicLabel = {
        let view = BasicLabel()
        view.textAlignment = .left
        view.font = .custom(size: 24, weight: .bold)
        view.textInsets = .init(bottom: 10, left: 16)
        return view
    }()
    
    private(set) lazy var barChartView: BarChartView = {
       let view = BarChartView()
        view.highlightFullBarEnabled = true
        view.xAxis.valueFormatter = IndexAxisValueFormatter(values: DateFormatter().standaloneMonthSymbols)
        view.xAxis.drawAxisLineEnabled = false
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawAxisLineEnabled = false
        view.rightAxis.drawAxisLineEnabled = false
        view.leftAxis.drawLabelsEnabled = false
        view.leftAxis.drawTopYLabelEntryEnabled = false
        view.leftAxis.drawZeroLineEnabled = false
        view.doubleTapToZoomEnabled = false
        view.pinchZoomEnabled = false
        view.drawBordersEnabled = false
        view.dragEnabled = false
        view.scaleXEnabled = false
        view.scaleYEnabled = false
        view.legend.enabled = false
        view.rightAxis.drawLabelsEnabled = false
        view.xAxis.labelFont = .custom(size: 12, weight: .regular)
        view.leftAxis.labelFont = .custom(size: 10, weight: .regular)
        view.xAxis.labelCount = 12
        view.xAxis.labelRotationAngle = -45
//        let leftAxisFormatter = NumberFormatter()
//        leftAxisFormatter.positiveSuffix = .empty.appendCurrency()
//        view.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        view.animate(xAxisDuration: 0.3, yAxisDuration: 0.4)
        return view
    }()
    
    private(set) lazy var yearBarStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.spacing = 5
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.contentInset = UIEdgeInsets(horizontal: 16)
        return stack
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
        addSubview(descriptionLabel)
        customMarkerView.chartView = barChartView
        barChartView.marker = customMarkerView
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let chartHight = screenWidth - 70
        barChartView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
            make.height.equalTo(chartHight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(25)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        descriptionLabel.setViewModel(vm.descriptionLabelVM)
        
        vm.changePeriodSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.barChartView.highlightValue(nil)
                self?.barChartView.animate(xAxisDuration: 0.3, yAxisDuration: 0.4)
        }
        .store(in: &cancellables)
        
    }
}

extension BarChart: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
}
