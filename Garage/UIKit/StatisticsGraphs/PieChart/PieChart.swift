//
//  PieChart.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 29.07.23.
//

import UIKit
import DGCharts
import SnapKit

class PieChart: BasicView {
    var viewModel: ViewModel?
    
    lazy var customMarkerView = CustomMarkerView(frame: .zero, for: .pie)
    
    private lazy var containerView = BasicView()
    
    private(set) lazy var pieChartView: PieChartView = {
        let view = PieChartView()
        view.drawEntryLabelsEnabled = false
        view.legend.enabled = false
        return view
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
        addSubview(containerView)
        containerView.addSubview(pieChartView)
        customMarkerView.chartView = pieChartView
        pieChartView.marker = customMarkerView
    }
    
    private func makeConstraints() {
        let screenWidth = UIScreen.main.bounds.width
        let chartHight = screenWidth - 70
        
        containerView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
            make.height.equalTo(chartHight)
            make.edges.equalToSuperview()
        }
        
        pieChartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            make.top.bottom.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.viewModel = vm
    }
}

extension PieChart: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    
        let animator = Animator()
        
        animator.updateBlock = {
            let phaseShift = 15 * animator.phaseX
            
            let dataSet = chartView.data?.dataSets.first as? PieChartDataSet
            dataSet?.selectionShift = CGFloat(phaseShift)
            
            chartView.setNeedsDisplay()
        }

        animator.animate(xAxisDuration: 0.3, easingOption: ChartEasingOption.easeInQuart)
        
        viewModel?.records = RealmManager<Record>().read().filter({[weak self] record in
            guard let self,
                  let year = self.viewModel?.year else {
                if record.short == entry.data as? String {
                    return true
                }
                return false
            }
            
            if record.short == entry.data as! String,
               record.date.components.year == year {
                return true
            } else {
                return false
            }
        })
    }
}
