//
//  ServicesViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

class ServicesViewController: BasicViewController {

    // - UI
    typealias Coordinator = ServicesControllerCoordinator
    typealias Layout = ServicesControllerLayoutManager
    
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

extension ServicesViewController {

    private func configureCoordinator() {
        coordinator = ServicesControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = ServicesControllerLayoutManager(vc: self)
    }
    
}
