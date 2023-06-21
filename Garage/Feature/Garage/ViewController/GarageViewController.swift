//
//  GarageViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

class GarageViewController: BasicViewController {

    // - UI
    typealias Coordinator = GarageControllerCoordinator
    typealias Layout = GarageControllerLayoutManager
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readCars()
        hideTabBar(false)
        makeLogoNavbar()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        super.binding()
        layout.table.setViewModel(vm.tableVM)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cells in
                self?.layout.table.reload()
            }
            .store(in: &cancellables)
    }
    
}

// MARK: -
// MARK: - Configure

extension GarageViewController {

    private func configureCoordinator() {
        coordinator = Coordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = Layout(vc: self)
    }
    
}

extension GarageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  vm.tableVM.cells.count == 0 ? 0 : vm.tableVM.cells.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == vm.tableVM.cells.count {
            guard let addCarCell = tableView.dequeueReusableCell(AddCarCell.self) else { return .init() }
            addCarCell.mainView.setViewModel(.init())
            addCarCell.selectionStyle = .none
            return addCarCell
        }
        
        guard let carCell = tableView.dequeueReusableCell(CarCell.self),
              let vm = vm.tableVM.cells[safe: indexPath.row]
        else { return .init() }
        carCell.mainView.setViewModel(.init(car: vm))
        carCell.selectionStyle = .none
        return carCell
    }
}

extension GarageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == vm.tableVM.cells.count {
            self.coordinator.navigateTo(GarageNavigationRoute.createCar)
            return
        }
        
        guard let selectedCar = vm.tableVM.cells[safe: indexPath.row] else { return }
        coordinator.navigateTo(GarageNavigationRoute.openCar(selectedCar))
    }
}
