//
//  MostFrequentOpeartionController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 17.09.23.
//  
//

import UIKit

class MostFrequentOpeartionViewController: BasicViewController {

    // - UI
    typealias Coordinator = MostFrequentOpeartionControllerCoordinator
    typealias Layout = MostFrequentOpeartionControllerLayoutManager
    
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
        title = "Самая популярная операция"
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.tableView.setViewModel(vm.tableVM)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.layout.tableView.reload()
            })
            .store(in: &cancellables)
    }
}

// MARK: -
// MARK: - Configure

extension MostFrequentOpeartionViewController {

    private func configureCoordinator() {
        coordinator = MostFrequentOpeartionControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = MostFrequentOpeartionControllerLayoutManager(vc: self)
    }
    
}

// MARK: - UITableViewDataSource
extension MostFrequentOpeartionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        vm.headers.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.tableVM.cells[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let yearHeaderCell = tableView.dequeueReusableCell(BasicTableCell<DateHeaderView>.self, for: indexPath) else { return .init() }
            yearHeaderCell.mainView.setViewModel(vm.headers[indexPath.section])
            yearHeaderCell.selectionStyle = .none
            return yearHeaderCell
        }
        
        guard let recordCell = tableView.dequeueReusableCell(RecordCell.self, for: indexPath) else { return .init()}
        recordCell.mainView.setViewModel(vm.tableVM.cells[indexPath.section][indexPath.row - 1])
        recordCell.selectionStyle = .none
        return recordCell
    }
}

// MARK: - UITableViewDelegate
extension MostFrequentOpeartionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = vm.tableVM.cells[indexPath.section][indexPath.row - 1].record
        coordinator.navigateTo(MostFrequentOpeartionNavigationRoute.record(vm.car, record))
    }
}
