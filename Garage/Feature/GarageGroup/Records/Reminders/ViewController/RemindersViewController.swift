//
//  RemindersViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 5.07.23.
//  
//

import UIKit

class RemindersViewController: BasicViewController {

    // - UI
    typealias Coordinator = RemindersControllerCoordinator
    typealias Layout = RemindersControllerLayoutManager
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewDelegate = layout.table.table
        
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.table.setViewModel(vm.tableVM)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cells  in
                self?.layout.table.reload()
            }
            .store(in: &cancellables)
    }
    
}

// MARK: -
// MARK: - Configure

extension RemindersViewController {

    private func configureCoordinator() {
        coordinator = RemindersControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = RemindersControllerLayoutManager(vc: self)
    }
    
}

// MARK: - UITableViewDataSource
extension RemindersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pastRecordCell = tableView.dequeueReusableCell(BasicTableCell<ReminderView>.self, for: indexPath) else { return .init()}
        
        let reminderVM = ReminderView.ViewModel(reminder: vm.tableVM.cells[indexPath.row]) { [weak self] reminder in
            self?.vm.completeReminder?(reminder)
        }

        pastRecordCell.mainView.setViewModel(reminderVM)
        pastRecordCell.selectionStyle = .none
        return pastRecordCell
    }

}

// MARK: - UITableViewDelegate

extension RemindersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
