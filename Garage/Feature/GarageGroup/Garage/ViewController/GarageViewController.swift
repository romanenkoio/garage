//
//  GarageViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import CoreLocation
import SPIndicator

class GarageViewController: BasicViewController {
    
    // - UI
    typealias Coordinator = GarageControllerCoordinator
    typealias Layout = GarageControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    private lazy var locationManager = CLLocationManager()
    private var indexPath: IndexPath?
    
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
        let isFirst: Bool = SettingsManager.sh.read(.isFirstLaunch) ?? true
//        if isFirst {
            coordinator.navigateTo(GarageNavigationRoute.onboarding)
//        }
        LocationManager.shared.checkLocationService()
        switch LocationManager.shared.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.vm.isLocationEnabled = true
            self.locationManager.delegate = self
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readCars()
        hideTabBar(false)
        makeNavbar()
    }
    
    private func makeNavbar() {
        makeLogoNavbar()
        let settingButtonVM = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                self?.coordinator.navigateTo(GarageNavigationRoute.settings)
            },
            image: UIImage(named: "settings")
        )
        makeRightNavBarButton(buttons: [settingButtonVM])
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
        
        vm.addButtonVM.buttonVM.action = .touchUpInside { [weak self] in
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.cars.isEmpty ? 0 : vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  vm.cars.isEmpty ? 0 : vm.tableVM.cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = vm.tableVM.cells[safe: indexPath.section]?[safe: indexPath.row] else { return .init() }
        
        switch cell {
        case .banner:
            guard let bannerCell = tableView.dequeueReusableCell(BannerCell.self)
            else { return .init() }
            bannerCell.mainView.insets = .init(horizontal: 20)
            bannerCell.mainView.setViewModel(.init())
            bannerCell.selectionStyle = .none
            return bannerCell
        case .car:
            guard let carCell = tableView.dequeueReusableCell(CarCell.self),
                  let vm = vm.cars[safe: indexPath.row]
            else { return .init() }
            carCell.mainView.setViewModel(.init(car: vm))
            carCell.selectionStyle = .none
            return carCell
        case .addCar:
            guard let addCarCell = tableView.dequeueReusableCell(AddCarCell.self) else { return .init() }
            addCarCell.mainView.setViewModel(.init())
            addCarCell.selectionStyle = .none
            return addCarCell
        }
    }
    
}

extension GarageViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let cell = vm.tableVM.cells[safe: indexPath.section]?[safe: indexPath.row] else { return }

        switch cell {
            
        case .banner:
            break
        case .car:
            guard let selectedCar = vm.cars[safe: indexPath.row] else { return }
            coordinator.navigateTo(GarageNavigationRoute.openCar(selectedCar))
        case .addCar:
            let cars: [Car] = RealmManager().read()
            if !Environment.isPrem, cars.count >= 1 {
                self.coordinator.navigateTo(CommonNavigationRoute.premium)
            } else {
                self.coordinator.navigateTo(GarageNavigationRoute.createCar)
            }
            return
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { [weak self] suggestedActions -> UIMenu? in
            
            guard let self,
                  let cell = vm.tableVM.cells[safe: indexPath.section]?[safe: indexPath.row],
                  cell == .car,
                  vm.isLocationEnabled == true,
                  let car = vm.cars[safe: indexPath.row]
            else { return nil }
            
            let isHaveParking = !RealmManager<Parking>().read().filter({ $0.carID == car.id}).isEmpty
            
            let parkingAction = UIAction(
                title: "Запомнить парковку",
                image: UIImage(systemName: "parkingsign.circle")
            ) { [weak self] action in
                self?.vm.selectedCar = car
                self?.locationManager.startUpdatingLocation()
                self?.indexPath = indexPath
            }
            
            let showParkingLocation = UIAction(
                title: "Найти машину",
                image: UIImage(systemName: "location.magnifyingglass")
            ) { [weak self] action in
                self?.coordinator.navigateTo(GarageNavigationRoute.findCar(car))
            }
            
            let removeParkingLocation = UIAction(
                title: "Удалить парковку",
                image: UIImage(systemName: "trash.circle")
            ) { [weak self] action in
                guard let self else { return }
                self.vm.selectedCar = car
                self.vm.removeParkingLocation()
                SPIndicator.show(title: "Парковка удалена")
                guard let carCell = layout.table.table.cellForRow(at: indexPath) as? CarCell else { return }
                carCell.mainView.parkingImage.isHidden = true
            }
            
            var menu: [UIMenuElement] = .empty
            if isHaveParking {
                menu = [parkingAction, showParkingLocation, removeParkingLocation]
            } else {
                menu = [parkingAction]

            }
            return UIMenu(title: .empty, children: menu)
            
        })
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 0 : 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension GarageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = locations.last else { return }
        print(locValue.horizontalAccuracy)
        Task {
            if locValue.horizontalAccuracy < 30 {
                vm.setParkingMode(from: locValue)
                print("locations = \(locValue.coordinate.latitude), \(locValue.coordinate.longitude)")
                locationManager.stopUpdatingLocation()
                
                await MainActor.run {
                    guard let indexPath,
                          let carCell = layout.table.table.cellForRow(at: indexPath) as? CarCell
                    else { return }
                    carCell.mainView.parkingImage.isHidden = false
                    SPIndicator.show(title: "Парковка записана!")
                }
            }
        }
    }
}
