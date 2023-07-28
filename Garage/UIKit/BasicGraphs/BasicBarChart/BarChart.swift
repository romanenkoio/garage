//
//  BasicBarChart.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.07.23.
//

import Foundation
import DGCharts
import UIKit

class BarChart: BasicView {
    lazy var descriptionLabel: BasicLabel = {
        let view = BasicLabel()
        view.textAlignment = .left
        view.font = .custom(size: 24, weight: .bold)
        view.textInsets = .init(bottom: 25, left: 16)
        return view
    }()
    
    private(set) lazy var barChartView: BarChartView = {
       let view = BarChartView()
        view.highlightFullBarEnabled = true
        view.xAxis.valueFormatter = IndexAxisValueFormatter(values: DateFormatter().shortMonthSymbols)
        view.xAxis.drawAxisLineEnabled = false
        view.xAxis.drawGridLinesEnabled = false
        view.doubleTapToZoomEnabled = false
        view.pinchZoomEnabled = false
        view.drawBordersEnabled = false
        view.dragEnabled = false
        view.scaleXEnabled = false
        view.scaleYEnabled = false
//        view.legend.enabled = false
        view.rightAxis.drawLabelsEnabled = false

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
        addSubview(yearBarStack)
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        barChartView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
        
        yearBarStack.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(barChartView.snp.bottom).inset(UIEdgeInsets(top: 10))
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        descriptionLabel.setViewModel(vm.descriptionLabelVM)
        
        vm.changePeriodSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.barChartView.highlightValue(nil)
        }
        .store(in: &cancellables)
    }
}

extension BarChart: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
}
