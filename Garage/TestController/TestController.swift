//
//  TestController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import UIKit
import DGCharts

class TestController: BasicViewController {
    lazy var barChart = BasicBarChart()
    
    let vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableScrollView()
    }
    
    override func makeConstraints() {
        barChart.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    override func layoutElements() {
        contentView.addSubview(barChart)

    }
    
    override func binding() {
        barChart.setViewModel(vm.barChart)
        
        vm.barChart.$barChartData
            .receive(on: DispatchQueue.main)
            .sink { data in
                self.barChart.barChartView.data = data
            }
            .store(in: &cancellables)
    }
}

