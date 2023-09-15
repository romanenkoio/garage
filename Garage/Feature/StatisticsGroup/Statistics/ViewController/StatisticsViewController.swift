//
//  StatisticsViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.08.23.
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

extension StatisticsViewController {

    private func configureCoordinator() {
        coordinator = StatisticsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = StatisticsControllerLayoutManager(vc: self)
    }
    
}

// MARK: - DataSource

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
        
        guard let statCell = tableView.dequeueReusableCell(StatisticCell.self, for: indexPath) else { return .init() }
        
//        statCell.mainView.setViewModel(.init(cellValue: vm.tableVM.cells[indexPath.row]))
        statCell.mainView.setViewModel(vm.tableVM.cells[indexPath.section][indexPath.row - 1])
        statCell.selectionStyle = .none
        return statCell
    }
}

// MARK: - Delegate

extension StatisticsViewController: UITableViewDelegate {
    
}
