//
//  CreateRepairViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 10.06.23.
//  
//

import UIKit

class CreateRepairViewController: BasicViewController {

    // - UI
    typealias Coordinator = CreateRepairControllerCoordinator
    typealias Layout = CreateRepairControllerLayoutManager
    
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

extension CreateRepairViewController {

    private func configureCoordinator() {
        coordinator = CreateRepairControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CreateRepairControllerLayoutManager(vc: self)
    }
    
}
