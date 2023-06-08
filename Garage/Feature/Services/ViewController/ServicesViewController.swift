//
//  ServicesViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import SwiftUI

class ServicesViewController: BasicViewController {

    // - UI
    typealias Coordinator = ServicesControllerCoordinator
    typealias Layout = ServicesControllerLayoutManager
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readServices()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.table.setViewModel(vm.tableVM)
    }
    
}

// MARK: -
// MARK: - Configure

extension ServicesViewController {

    private func configureCoordinator() {
        coordinator = ServicesControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = ServicesControllerLayoutManager(vc: self)
    }
    
}

extension ServicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(ServiceCell.self, for: indexPath) else { return .init() }
        serviceCell.mainView.setViewModel(vm.tableVM.cells[indexPath.row])
        return serviceCell
    }
}

extension ServicesViewController: UITableViewDelegate {
    
}
