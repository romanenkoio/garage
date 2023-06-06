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
        layout.addCarButton.setViewModel(vm.addCarButton)
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
