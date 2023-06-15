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
        
        vm.tableVM.addButtonVM.action = .touchUpInside { [weak self] in
            guard let self else { return }
            coordinator.navigateTo(DocumentsNavigationRoute.createDocument)
        }
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
        return serviceCell
    }
}

extension DocumentsViewController: UITableViewDelegate {
    
}
