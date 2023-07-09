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
        setupNavBar()
    }
    
    private func setupNavBar() {
        makeCloseButton(isLeft: true)
        
        guard case .edit(_) = vm.mode else {
            title = "Добавление сервиса"
            return
        }
        
        let deleteButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                let vm = Popup.ViewModel(titleVM: .init(text: "Вы уверены, что хотите удалить сервис?"))
                vm.confirmButton.action = .touchUpInside { [weak self] in
                    self?.vm.removeService() { [weak self] in
                        self?.dismiss(animated: true)
                        self?.coordinator.navigateTo(CommonNavigationRoute.close)
                    }
                }
                self?.coordinator.navigateTo(CommonNavigationRoute.confirmPopup(vm: vm))
            },
            image: UIImage(named: "delete_ic")
        )
        title = "Изменение сервиса"
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
        layout.commentInput.setViewModel(vm.commenntInputVM)
        
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
