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
        let isFirst: Bool? = SettingsManager.sh.read(.isFirstLaunch)
        if isFirst == true || isFirst == nil {
            coordinator.navigateTo(GarageNavigationRoute.onboarding)
        }
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
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.row == vm.tableVM.cells.count {
            let isPrem: Bool = SettingsManager.sh.read(.isPremium) ?? false
            let cars: [Car] = RealmManager().read()
            if !isPrem, cars.count >= 1 {
//                show premium
            } else {
                self.coordinator.navigateTo(GarageNavigationRoute.createCar)
            }
            return
        }
        
        guard let selectedCar = vm.tableVM.cells[safe: indexPath.row] else { return }
        coordinator.navigateTo(GarageNavigationRoute.openCar(selectedCar))
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { [weak self] suggestedActions -> UIMenu? in
            
            guard let self,
                  vm.isLocationEnabled == true,
                  let car = vm.tableVM.cells[safe: indexPath.row]
            else { return nil }
            
            let isHaveParking = !RealmManager<Parking>().read().filter({ $0.carID == car.id}).isEmpty
            
            let parkingAction = UIAction(
                title: "Припарковаться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { [weak self] action in
                self?.vm.selectedCar = car
                self?.locationManager.startUpdatingLocation()
                self?.indexPath = indexPath
            }
            
            let showParkingLocation = UIAction(
                title: "Найти машину",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { [weak self] action in
                
                
            }
            
            let removeParkingLocation = UIAction(
                title: "Удалить парковку",
                image: UIImage(systemName: "square.and.arrow.up")
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
