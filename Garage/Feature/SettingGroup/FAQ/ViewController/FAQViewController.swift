//
//  FAQViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 11.09.23.
//  
//

import UIKit

class FAQViewController: BasicViewController {

    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: FAQControllerCoordinator!
    private var layout: FAQControllerLayoutManager!
    
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
        makeCloseButton(side: .left)
        disableScrollView()
        title = "Периоды ТО"
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

fileprivate extension FAQViewController {
    
    private func configureCoordinator() {
        coordinator = FAQControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = FAQControllerLayoutManager(vc: self)
    }
    
}

extension FAQViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells[safe: section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let faqCell = tableView.dequeueReusableCell(BasicTableCell<FAQView>.self),
              let point = vm.cells[safe: indexPath.section]?[safe: indexPath.row]
        else { return .init()}
        faqCell.mainView.setViewModel(.init(point))
        return faqCell
    }
}

extension FAQViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = vm.cells[safe: section]?.first?.header else { return nil }
        let label = BasicLabel(font: .custom(size: 16, weight: .semibold))
        label.textColor = AppColors.blue
        label.textInsets = .init(top: 10, bottom: 15)
        label.setViewModel(.init(.text(header)))
        return label
    }
}
