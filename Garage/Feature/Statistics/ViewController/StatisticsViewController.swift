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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.maxConstraintConstant = layout.chartsView.frame.size.height
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        if let chartsViewVM = vm.chartsViewVM {
            layout.chartsView.setViewModel(chartsViewVM)
        }
        
        layout.table.setViewModel(vm.tableVM)
        
        layout.chartsView.barChart.viewModel?.$records
            .sink(receiveValue: {[weak self] barChartRecords in
                guard let self else { return }
                vm.createRecords(from: barChartRecords)
            })
            .store(in: &cancellables)
        
        layout.chartsView.pieChart.viewModel?.$records
            .sink(receiveValue: {[weak self] pieChartRecords in
                guard let self else { return }
                vm.createRecords(from: pieChartRecords)
            })
            .store(in: &cancellables)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink {[weak self] cells in
                guard let self else { return }
                self.layout.table.reload()
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

//MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let pastRecordCell = tableView.dequeueReusableCell(BasicTableCell<DateHeaderView>.self, for: indexPath) else { return .init() }
            pastRecordCell.mainView.setViewModel(vm.headers[indexPath.section])
            pastRecordCell.selectionStyle = .none
            return pastRecordCell
        }
        
        
        guard let pastRecordCell = tableView.dequeueReusableCell(RecordCell.self, for: indexPath) else { return .init()}
        pastRecordCell.mainView.setViewModel(vm.tableVM.cells[indexPath.section][indexPath.row - 1])
        pastRecordCell.selectionStyle = .none
        return pastRecordCell
    }
    
}

//MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
    
}
