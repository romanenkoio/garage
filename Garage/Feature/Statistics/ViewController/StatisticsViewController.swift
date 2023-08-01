//
//  StatisticsViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCloseButton(isLeft: true)
        disableScrollView()
        title = "Статистика"
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        guard let flipVM = vm.flipviewVM else { return }
        layout.flipView.setViewModel(flipVM)
        
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
