//
//  ParkingMapViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 24.07.23.
//  
//

import UIKit
import GoogleMaps
import SPIndicator

class ParkingMapViewController: BasicViewController {

    // - UI
    typealias Coordinator = ParkingMapControllerCoordinator
    typealias Layout = ParkingMapControllerLayoutManager
    
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
        makeCarPin()
        makeCloseButton(side: .left)
        if let dateString = vm.parking?.date.toString(.MMddyyyyHHmm) {
            self.title = "Парковка: \(dateString)"
        }
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        self.layout.removeParkingButton.setViewModel(vm.removeParkingButtonVM)
        
        vm.removeParkingButtonVM.buttonVM.action = .touchUpInside { [weak self] in
            self?.vm.removeParking()
            self?.coordinator.navigateTo(CommonNavigationRoute.closeToRoot)
            SPIndicator.show(title: "Парковка удалена")
        }
    }
    
    private func makeCarPin() {
        guard let parking = vm.parking else { return }
        let location = CLLocationCoordinate2D(
            latitude: parking.latitude,
            longitude: parking.longitude
        )
        
        let pin = GMSMarker(position: location)
        let pinView = CarPinView()
        pinView.setViewModel(.init(car: vm.car))
        pin.iconView = pinView
        pin.map = layout.mapView
        
        let camera = GMSCameraPosition(
            latitude: location.latitude,
            longitude: location.longitude,
            zoom: 15
        )
        layout.mapView.camera = camera
        
        let circ = GMSCircle(position: location, radius: parking.accuracy)
        circ.fillColor = .black.withAlphaComponent(0.1)
        circ.map = layout.mapView
    }
}

// MARK: -
// MARK: - Configure

extension ParkingMapViewController {

    private func configureCoordinator() {
        coordinator = ParkingMapControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = ParkingMapControllerLayoutManager(vc: self)
    }
    
}
