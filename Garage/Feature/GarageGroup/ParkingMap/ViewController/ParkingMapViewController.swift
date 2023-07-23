//
//  ParkingMapViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 24.07.23.
//  
//

import UIKit

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
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        
    }
    
}

// MARK: -
// MARK: - Configure

extension ParkingMapViewController {

    private func configureCoordinator() {
        coordinator = ParkingMapControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layoutManager = ParkingMapControllerLayoutManager(vc: self)
    }
    
}
