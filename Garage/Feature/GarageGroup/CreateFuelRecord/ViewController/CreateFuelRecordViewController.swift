//
//  CreateFuelRecordViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 26.09.23.
//  
//

import UIKit

class CreateFuelRecordViewController: BasicViewController {

    // - UI
    typealias Coordinator = CreateFuelRecordControllerCoordinator
    typealias Layout = CreateFuelRecordControllerLayoutManager
    
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
        makeCloseButton(side: .left)

        guard case .edit(_) = vm.mode else {
            title = "Создание записи"
          return
        }

        title = "Изменение записи"
        let deleteButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                let vm = Dialog.ViewModel(title: .text("Вы уверены, что хотите удалить запись?")) { [weak self] in
                    self?.vm.removeRecord() {
                        [weak self] in
                        self?.coordinator.navigateTo(CommonNavigationRoute.close)
                    }
                }
                self?.coordinator.navigateTo(CommonNavigationRoute.confirmPopup(vm: vm))
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
        layout.costInput.setViewModel(vm.costInputVM)
        layout.dateInput.setViewModel(vm.dateInputVM)
        layout.qauntityInput.setViewModel(vm.quantityInputVM)
        layout.saveButton.setViewModel(vm.saveButtonVM)
        
        vm.saveButtonVM.buttonVM.action = .touchUpInside { [weak self] in
            guard let self else { return }
            self.vm.action()
            self.coordinator.navigateTo(CommonNavigationRoute.close)
        }
    }
}

// MARK: -
// MARK: - Configure

extension CreateFuelRecordViewController {

    private func configureCoordinator() {
        coordinator = CreateFuelRecordControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CreateFuelRecordControllerLayoutManager(vc: self)
    }
    
}
