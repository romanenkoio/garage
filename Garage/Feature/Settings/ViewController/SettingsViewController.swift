//
//  SettingsViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//  
//

import UIKit

class SettingsViewController: BasicViewController {

    // - UI
    typealias Coordinator = SettingsControllerCoordinator
    typealias Layout = SettingsControllerLayoutManager
    
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
        hideTabBar(false)
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

extension SettingsViewController {

    private func configureCoordinator() {
        coordinator = SettingsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = SettingsControllerLayoutManager(vc: self)
    }
    
}
