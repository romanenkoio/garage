//
//  SelectionViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

class SelectionViewController: BasicViewController {

    // - UI
    typealias Coordinator = SelectionControllerCoordinator
    typealias Layout = SelectionControllerLayoutManager
    
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
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.saveButton.setViewModel(vm.saveButtonVM)
        
        vm.$cells.sink { [weak self] _ in
            self?.layout.table.reloadData()
        }
        .store(in: &cancellables)
    }
    
}

// MARK: -
// MARK: - Configure

extension SelectionViewController {

    private func configureCoordinator() {
        coordinator = SelectionControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = SelectionControllerLayoutManager(vc: self)
    }
    
}

extension SelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectionCell = tableView.dequeueReusableCell(SelectCell.self, for: indexPath) else { return .init() }
        selectionCell.mainView.setViewModel(vm.cells[indexPath.row])
        return selectionCell
    }
    
    
}

extension SelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.selectCell(at: indexPath)
    }
}
