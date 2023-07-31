//
//  StatisticsViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//  
//

import UIKit

class StatisticsViewController: BasicViewController {

    // - UI
    typealias Coordinator = StatisticsControllerCoordinator
    typealias Layout = StatisticsControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
    private var layout: Layout!
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCloseButton(isLeft: true)
        disableScrollView()
        title = "Статистика"
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.flipView.setViewModel(vm.flipviewVM)
        
        layout.barChart.setViewModel(vm.barChartVM)
        
        vm.barChartVM.$barChartData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.layout.barChart.barChartView.data = data
            }
            .store(in: &cancellables)
        
        vm.barChartVM.$suggestions.sink { [weak self] vms in
            guard !vms.isEmpty else {
                self?.layout.barChart.yearBarStack.isHidden = true
                return
            }
            self?.layout.barChart.yearBarStack.clearArrangedSubviews()
            vms.forEach { [weak self] vm in
                let view = SuggestionView()
                view.setViewModel(vm)
                self?.layout.barChart.yearBarStack.addArrangedSubview(view)
            }
        }
        .store(in: &cancellables)
        
        layout.pieChart.setViewModel(vm.pieChartVM)
        
        vm.pieChartVM.$pieChartData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.layout.pieChart.pieChartView.data = data
            }
            .store(in: &cancellables)
        
        vm.pieChartVM.$suggestions.sink { [weak self] vms in
            guard !vms.isEmpty else {
                self?.layout.pieChart.yearBarStack.isHidden = true
                return
            }
            self?.layout.pieChart.yearBarStack.clearArrangedSubviews()
            vms.forEach { [weak self] vm in
                let view = SuggestionView()
                view.setViewModel(vm)
                self?.layout.pieChart.yearBarStack.addArrangedSubview(view)
            }
        }
        .store(in: &cancellables)
        
        vm.pieChartVM.$dataEntries
            .sink {[weak self] dataEntry in
                let textFormatter = TextFormatter()
                self?.layout.pieChart.pieChartView.centerAttributedText = textFormatter.attrinutedLines(
                    main: "Итого",
                    font: .custom(size: 14, weight: .medium),
                    secondary: "\(dataEntry.map({$0.value}).reduce(0, +))",
                    secondaryFont: .custom(size: 16, weight: .semibold),
                    lineSpacing: 2)
            }
            .store(in: &cancellables)
    }
    
}

// MARK: -
// MARK: - Configure

extension StatisticsViewController {

    private func configureCoordinator() {
        coordinator = StatisticsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = StatisticsControllerLayoutManager(vc: self)
    }
    
}
