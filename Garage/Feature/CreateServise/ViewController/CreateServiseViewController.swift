//
//  CreateServiseViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//  
//

import UIKit

class CreateServiseViewController: BasicViewController {

    // - UI
    typealias Coordinator = CreateServiseControllerCoordinator
    typealias Layout = CreateServiseControllerLayoutManager
    
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
        title = "Добавление сервиса"
        makeCloseButton(isLeft: true)
        setupNavBar()
    }
    
    private func setupNavBar() {
        let deleteButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                self?.vm.removeCar()
            },
            image: UIImage(named: "delete_ic")
        )
        makeRightNavBarButton(buttons: [deleteButton])
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.saveButton.setViewModel(vm.saveButtonVM)
        layout.nameInput.setViewModel(vm.nameInputVM)
        layout.phoneInput.setViewModel(vm.phoneInputVM)
        layout.specialisationInput.setViewModel(vm.specialisationInputVM)
        layout.adressInput.setViewModel(vm.adressInputVM)
        
        vm.saveCompletion = { [weak self] in
            self?.coordinator.navigateTo(CommonNavigationRoute.close)
        }
    }
    
}

// MARK: -
// MARK: - Configure

extension CreateServiseViewController {

    private func configureCoordinator() {
        coordinator = CreateServiseControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CreateServiseControllerLayoutManager(vc: self)
    }
    
}
