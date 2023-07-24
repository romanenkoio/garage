//
//  ParkingMapViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 24.07.23.
//  
//

import UIKit
import GoogleMaps

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
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        
    }
    
    private func makeCarPin() {
        guard let parking = vm.parking else { return }
        let location = CLLocationCoordinate2D(
            latitude: parking.latitude,
            longitude: parking.longitude
        )
        
        let pin = GMSMarker(position: location)
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
