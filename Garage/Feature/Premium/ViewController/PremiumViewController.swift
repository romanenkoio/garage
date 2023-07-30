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
        hideTabBar(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(false)
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.logoImage.setViewModel(vm.logoImageVM)
        layout.closeImage.setViewModel(vm.closeImageVM)
        layout.toplabel.setViewModel(vm.topLabelVM)
        layout.startTrialButton.setViewModel(vm.startTrialButton)
        layout.privacyLabel.setViewModel(vm.privacyVM)
        layout.termsLabel.setViewModel(vm.termsVM)
        layout.restoreLabel.setViewModel(vm.restoreVM)
        vm.closeImageVM.action = { [weak self] in
            self?.coordinator.navigateTo(CommonNavigationRoute.close)
        }
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
