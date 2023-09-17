//
//  StatisticViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.08.23.
//  
//

import UIKit

class StatisticViewController: BasicViewController {

    // - UI
    typealias Coordinator = StatisticControllerCoordinator
    typealias Layout = StatisticControllerLayoutManager
    
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
        disableScrollView()
        makeCloseButton(side: .left)
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.tableView.setViewModel(vm.tableVM)
        
        vm.tableVM.$cells
            .sink {[weak self] _ in
                self?.layout.tableView.reload()
            }
            .store(in: &cancellables)
    }
}

// MARK: -
// MARK: - Configure

extension StatisticViewController {

    private func configureCoordinator() {
        coordinator = StatisticControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = StatisticControllerLayoutManager(vc: self)
    }
    
}

// MARK: - DataSource

extension StatisticViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let yearHeaderCell = tableView.dequeueReusableCell(BasicTableCell<DateHeaderView>.self, for: indexPath) else { return .init() }
            yearHeaderCell.mainView.setViewModel(vm.headers[indexPath.section])
            yearHeaderCell.selectionStyle = .none
            return yearHeaderCell
        }
        
        guard let statCell = tableView.dequeueReusableCell(StatisticCell.self, for: indexPath) else { return .init() }
        
        statCell.mainView.setViewModel(vm.tableVM.cells[indexPath.section][indexPath.row - 1])
        statCell.selectionStyle = .none
        return statCell
    }
}

// MARK: - Delegate

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let record = vm.tableVM.cells[indexPath.section][indexPath.row - 1].cellValue.statValue.record {
            coordinator.navigateTo(StatisticNavigationRoute.editRecord(vm.car, record))
        }
        
        if case .mostFreqOperation(_) = vm.tableVM.cells[indexPath.section][indexPath.row - 1].cellValue {
            
            guard let operationType = vm.tableVM.cells[indexPath.section][indexPath.row - 1].cellValue.statValue.stringValue else { return }
            coordinator.navigateTo(StatisticNavigationRoute.allRecords(vm.car, operationType))
        }
    }
}
