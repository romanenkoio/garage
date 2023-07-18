//
//  PastRecordsViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.06.23.
//  
//

import UIKit

class PastRecordsViewController: BasicViewController {
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: PastRecordsControllerCoordinator!
    var layout: PastRecordsControllerLayoutManager!
    
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

        layout.table.table.estimatedRowHeight = UITableView.automaticDimension
        tableViewDelegate = layout.table.table
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewDelegate = layout.table.table
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.removeFromSuperview()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.table.setViewModel(vm.tableVM)
        tableViewDelegate = layout.table.table
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

extension PastRecordsViewController {

    private func configureCoordinator() {
        coordinator = PastRecordsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = PastRecordsControllerLayoutManager(vc: self)
    }
}

// MARK: - UITableViewDataSource
extension PastRecordsViewController: UITableViewDataSource {
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

// MARK: - UITableViewDelegate

extension PastRecordsViewController: UITableViewDelegate {
}

extension PastRecordsViewController: PageControllable {
    var tableViewDelegate: UITableView? {
        get { tableView }
        set { tableView = newValue! }
    }

}
