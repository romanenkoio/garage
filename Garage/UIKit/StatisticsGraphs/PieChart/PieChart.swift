//
//  PieChart.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 29.07.23.
//

import UIKit
import DGCharts

class PieChart: BasicView {
    lazy var customMarkerView = CustomMarkerView(frame: .zero, for: .pie)
    
    lazy var descriptionLabel: BasicLabel = {
        let view = BasicLabel()
        view.textAlignment = .left
        view.font = .custom(size: 24, weight: .bold)
        view.textInsets = .init(bottom: 10, left: 16)
        return view
    }()
    
//    private(set) lazy var barChartView: BarChartView = {
//       let view = BarChartView()
//        view.highlightFullBarEnabled = true
//        view.xAxis.valueFormatter = IndexAxisValueFormatter(values: DateFormatter().standaloneMonthSymbols)
//        view.xAxis.drawAxisLineEnabled = false
//        view.xAxis.drawGridLinesEnabled = false
//        view.leftAxis.drawAxisLineEnabled = false
//        view.rightAxis.drawAxisLineEnabled = false
//        view.doubleTapToZoomEnabled = false
//        view.pinchZoomEnabled = false
//        view.drawBordersEnabled = false
//        view.dragEnabled = false
//        view.scaleXEnabled = false
//        view.scaleYEnabled = false
//        view.legend.enabled = false
//        view.rightAxis.drawLabelsEnabled = false
//        view.xAxis.labelFont = .custom(size: 12, weight: .regular)
//        view.leftAxis.labelFont = .custom(size: 10, weight: .regular)
//        view.xAxis.labelCount = 12
//        view.xAxis.labelRotationAngle = -45
//        let leftAxisFormatter = NumberFormatter()
//        leftAxisFormatter.positiveSuffix = " Br"
//        view.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
//        view.animate(xAxisDuration: 0.3, yAxisDuration: 0.4)
//        return view
//    }()
    
    private(set) lazy var centerLabel: BasicLabel = {
        let label = BasicLabel(frame: CGRect(x: 0, y: 0, width: pieChartView.frame.width, height: 40))
        label.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var pieChartView: PieChartView = {
        let view = PieChartView()
        view.drawEntryLabelsEnabled = false
        view.legend.enabled = false
        return view
    }()
    
    private(set) lazy var yearBarStackContentView = UIView()
    
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
        pieChartView.delegate = self
        makeLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(pieChartView)
        addSubview(descriptionLabel)
        addSubview(yearBarStack)
        customMarkerView.chartView = pieChartView
        pieChartView.marker = customMarkerView
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let chartHight = screenWidth - 70
        pieChartView.snp.makeConstraints { make in
            make.height.equalTo(chartHight)
            make.width.equalTo(screenWidth)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
        
        yearBarStack.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(pieChartView.snp.bottom).inset(UIEdgeInsets(top: 10))
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        descriptionLabel.setViewModel(vm.descriptionLabelVM)
        
        vm.changePeriodSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.pieChartView.highlightValue(nil)
                self?.pieChartView.animate(xAxisDuration: 0.3, yAxisDuration: 0.4)
            }
            .store(in: &cancellables)
        
    }
}

extension PieChart: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        
        let animator = Animator()
        
        animator.updateBlock = {
            // Usually the phase is a value between 0.0 and 1.0
            // Multiply it so you get the final phaseShift you want
            let phaseShift = 15 * animator.phaseX
            
            let dataSet = chartView.data?.dataSets.first as? PieChartDataSet
            // Set the selectionShift property to actually change the selection over time
            dataSet?.selectionShift = CGFloat(phaseShift)
            
            // In order to see the animation, trigger a redraw every time the selectionShift property was changed
            chartView.setNeedsDisplay()
        }
        
        // Start the animation by triggering the animate function with any timing function you like
        animator.animate(xAxisDuration: 0.3, easingOption: ChartEasingOption.easeInQuart)
        
    }
}
