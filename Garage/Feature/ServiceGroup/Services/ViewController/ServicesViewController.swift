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
    var layout: Layout!
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(layout.addButton)
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
        
        let action: Action = .touchUpInside { [weak self] in
            self?.coordinator.navigateTo(ServiceNavigationRoute.createService)
        }
        
        vm.tableVM.addButtonVM.action = action
        vm.addButtonVM.mainButtonAction = {
            action()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(ServiceCell.self, for: indexPath) else { return .init() }
        serviceCell.mainView.setViewModel(
            .init(service: vm.tableVM.cells[indexPath.section])
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
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { [weak self] suggestedActions -> UIMenu? in
            let copyAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { [weak self] action in
                guard let self,
                      let service = self.vm.tableVM.cells[safe: indexPath.row]
                else { return }
                
                guard let qr = QRGenerator().generateQRCode(from: service) else { return }
                coordinator.navigateTo(CommonNavigationRoute.share([qr]))
            }
            return UIMenu(title: .empty, children: [copyAction])
        })
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}


