//
//  StatisticsViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.08.23.
//  
//

import UIKit

class StatisticsViewController: BasicViewController {

    // - UI
    typealias Coordinator = StatisticsControllerCoordinator
    typealias Layout = StatisticsControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
    private var layout: Layout!
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init()
        disableScrollView()
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

extension StatisticsViewController {

    private func configureCoordinator() {
        coordinator = StatisticsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = StatisticsControllerLayoutManager(vc: self)
    }
    
}

// MARK: - DataSource

// MARK: - Delegate
