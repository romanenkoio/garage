//
//  DocumentsViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//  
//

import UIKit

class DocumentsViewController: BasicViewController {

    // - UI
    typealias Coordinator = DocumentsControllerCoordinator
    typealias Layout = DocumentsControllerLayoutManager
    
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
        vm.readDocuments()
        hideTabBar(false)
    }
    
    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.table.setViewModel(vm.tableVM)
        layout.addButton.setViewModel(vm.addButtonVM)
     
        let action: Action = .touchUpInside { [weak self] in
            guard let self else { return }
            coordinator.navigateTo(DocumentsNavigationRoute.createDocument)
        }

        vm.tableVM.addButtonVM.action = action
        vm.addButtonVM.mainButtonAction = {
            action()
        }
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cells in
                self?.layout.table.reload()
                self?.layout.addButton.isHidden = cells.isEmpty
            }
            .store(in: &cancellables)
    }
    
    override func hideKeyboard() {
        super.hideKeyboard()
    }
}

// MARK: -
// MARK: - Configure

extension DocumentsViewController {

    private func configureCoordinator() {
        coordinator = DocumentsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = DocumentsControllerLayoutManager(vc: self)
    }
    
}

extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(DocumentCell.self, for: indexPath),
              let item = vm.tableVM.cells[safe: indexPath.row]
        else { return .init() }
        serviceCell.mainView.setViewModel(.init(document: item))
        serviceCell.selectionStyle = .none
        return serviceCell
    }
}

extension DocumentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let document = vm.tableVM.cells[safe: indexPath.row] else { return }
        coordinator.navigateTo(DocumentsNavigationRoute.editDocument(document))
    }
}
