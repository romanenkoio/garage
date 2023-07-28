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
        title = "Статистика"
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.barChart.setViewModel(vm.barChartVM)
        
        vm.barChartVM.$barChartData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.layout.barChart.barChartView.data = data
            }
            .store(in: &cancellables)
        
        vm.$years.sink { [weak self] years in
            
            let view = SuggestionView()
            view.setViewModel(.init(labelVM: .init(
                .text("Весь период"),
                action: { [weak self] in
                    self?.vm.initBarCharts()
                }
            ), image: nil))
            self?.layout.yearBarStack.addArrangedSubview(view)
            
            years.forEach({ [weak self] year in
                let view = SuggestionView()
                view.setViewModel(.init(labelVM: .init(
                    .text(year.toString()),
                    action: { [weak self] in
                        self?.vm.initBarCharts(year: year)
                    }
                ), image: nil))
                self?.layout.yearBarStack.addArrangedSubview(view)
            })
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
