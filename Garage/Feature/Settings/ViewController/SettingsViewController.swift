//
//  SettingsViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//  
//

import UIKit

class SettingsViewController: BasicViewController {

    // - UI
    typealias Coordinator = SettingsControllerCoordinator
    typealias Layout = SettingsControllerLayoutManager
    
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
        hideTabBar(false)
        makeLogoNavbar()
        hideTabBar(false)
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        self.layout.table.setViewModel(vm.tableVM)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.layout.table.reload()
        }
        .store(in: &cancellables)
    }
    
}

// MARK: -
// MARK: - Configure

extension SettingsViewController {

    private func configureCoordinator() {
        coordinator = SettingsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = SettingsControllerLayoutManager(vc: self)
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingCell = tableView.dequeueReusableCell(BasicTableCell<SettingView>.self) else { return .init() }
        
        settingCell.mainView.setViewModel(.init())
        return settingCell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}
