//
//  MainViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 28.08.23.
//  
//

import UIKit

class StatisticPagesViewController: BasicViewController {

    // - UI
    typealias Coordinator = StatisticPagesControllerCoordinator
    typealias Layout = StatisticPagesControllerLayoutManager
    
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
        disableScrollView()
        makeCloseButton(isLeft: true)
        title = "\(vm.car.brand) \(vm.car.model)"
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.segment.setViewModel(vm.segmentVM)
    }
    
}

// MARK: -
// MARK: - Configure

extension StatisticPagesViewController {

    private func configureCoordinator() {
        coordinator = StatisticPagesControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = StatisticPagesControllerLayoutManager(vc: self)
    }
    
}
