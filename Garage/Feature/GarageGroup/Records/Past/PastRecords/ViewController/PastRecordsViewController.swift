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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pastRecordCell = tableView.dequeueReusableCell(RecordCell.self, for: indexPath) else { return .init()}
        pastRecordCell.mainView.setViewModel(vm.tableVM.cells[indexPath.row])
        pastRecordCell.selectionStyle = .none
        return pastRecordCell
    }
}

// MARK: - UITableViewDelegate

extension PastRecordsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
