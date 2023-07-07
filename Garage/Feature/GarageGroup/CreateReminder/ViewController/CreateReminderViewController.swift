//
//  CreateReminderViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 7.07.23.
//  
//

import UIKit

class CreateReminderViewController: BasicViewController {

    // - UI
    typealias Coordinator = CreateReminderControllerCoordinator
    typealias Layout = CreateReminderControllerLayoutManager
    
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
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.dateInput.setViewModel(vm.dateInputVM)
        layout.saveButton.setViewModel(vm.saveButtonVM)
        layout.shortTypeInput.setViewModel(vm.shortTypeVM)
        layout.commentInput.setViewModel(vm.commenntInputVM)
        
        vm.saveButtonVM.buttonVM.action = .touchUpInside { [weak self] in
            guard let self else { return }
            self.vm.action()
            self.coordinator.navigateTo(CommonNavigationRoute.close)
        }
    }
    
}

// MARK: -
// MARK: - Configure

extension CreateReminderViewController {

    private func configureCoordinator() {
        coordinator = CreateReminderControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CreateReminderControllerLayoutManager(vc: self)
    }
    
}
