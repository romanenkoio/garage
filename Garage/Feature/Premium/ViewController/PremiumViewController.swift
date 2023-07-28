//
//  PremiumViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//  
//

import UIKit

class PremiumViewController: BasicViewController {

    // - UI
    typealias Coordinator = PremiumControllerCoordinator
    typealias Layout = PremiumControllerLayoutManager
    
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

extension PremiumViewController {

    private func configureCoordinator() {
        coordinator = PremiumControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = PremiumControllerLayoutManager(vc: self)
    }
    
}
