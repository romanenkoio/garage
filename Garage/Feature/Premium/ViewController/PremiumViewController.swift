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
        
        vm.restoreVM.action = { [weak self] in
            QounversionPaidSubscriptionManager().restore { error in
                guard error == nil else { return }
                self?.coordinator.navigateTo(CommonNavigationRoute.close)
            }
        }
        
        vm.startTrialButton.action = .touchUpInside { [weak self] in
            guard let selectedPlan = self?.vm.plans.first(where: { $0.isSelected })?.subscription else { return }
            QounversionPaidSubscriptionManager().purchase(subscription: selectedPlan) { [weak self] error in
                guard error == nil else {
                    let dialogVM: Dialog.ViewModel = .init(
                        title: .text("Что-то пошло не так"),
                        subtitle: .text("Пожалуйста, попробуйте позже"),
                        style: .error
                    )
                    self?.view.showDialog(Dialog(vm: dialogVM))
                    self?.coordinator.navigateTo(CommonNavigationRoute.close)
                    return
                }
                
                let dialogVM: Dialog.ViewModel = .init(
                    title: .text("Спасибо за покупку!"),
                    subtitle: .text("Пожалуйста, перезупустите приложение"),
                    style: .success
                )
                self?.view.showDialog(Dialog(vm: dialogVM))
                self?.coordinator.navigateTo(CommonNavigationRoute.close)
            }
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
