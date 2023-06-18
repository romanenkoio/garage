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
    var coordinator: Coordinator!
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
        makeLogoNavbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readServices()
        hideTabBar(false)
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.table.setViewModel(vm.tableVM)
        layout.addButton.setViewModel(vm.addButtonVM)
        
        vm.$suggestions.sink { [weak self] items in
            self?.layout.hideCategoriesStack(items)
        }
        .store(in: &cancellables)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cells in
                self?.layout.table.reload()
                self?.layout.addButton.isHidden = cells.isEmpty
            }
            .store(in: &cancellables)
        
        vm.tableVM.addButtonVM.action = .touchUpInside { [weak self] in
            self?.coordinator.navigateTo(ServiceNavigationRoute.createService)
        }
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
        serviceCell.mainView.setViewModel(
            .init(service: vm.tableVM.cells[indexPath.row])
        )
        serviceCell.selectionStyle = .none
        return serviceCell
    }
}

extension ServicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let service = vm.tableVM.cells[safe: indexPath.row] else { return }
        coordinator.navigateTo(ServiceNavigationRoute.editService(service))
    }
}
