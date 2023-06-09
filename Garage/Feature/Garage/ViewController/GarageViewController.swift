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
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        super.binding()
        layout.addCarButton.setViewModel(vm.addCarButton)
        
        vm.$cells
            .sink { [weak self] _ in self?.layout.checkEmptyTable() }
            .store(in: &cancellables)
        
        vm.addCarButton.action = .touchUpInside { [weak self] in
            self?.coordinator.navigateTo(GarageNavigationRoute.createCar)
        }
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
        return vm.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let carCell = tableView.dequeueReusableCell(CarCell.self),
              let vm = vm.cells[safe: indexPath.row]
        else { return .init() }
        carCell.mainView.setViewModel(.init(
            brand: vm.brand,
            model: vm.model,
            logoURL: "https://46.175.171.150/cars-logos/api/images/\(vm.brand.lowercased())_resized.png"
        ))
        carCell.selectionStyle = .none
        return carCell
    }
}

extension GarageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCar = vm.cells[safe: indexPath.row] else { return }
    }
}
