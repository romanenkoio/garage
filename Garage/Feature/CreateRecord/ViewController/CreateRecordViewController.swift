//
//  CreateRecordViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 15.06.23.
//  
//

import UIKit

class CreateRecordViewController: BasicViewController {

    // - UI
    typealias Coordinator = CreateRecordControllerCoordinator
    typealias Layout = CreateRecordControllerLayoutManager
    
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
        layout.costInput.setViewModel(vm.costInputVM)
        layout.mileageImput.setViewModel(vm.mileageInputVM)
        layout.imageList.setViewModel(vm.imagePickerVM)
        layout.saveButton.setViewModel(vm.saveButtonVM)
        layout.servicesList.setViewModel(vm.serivesListVM)
    }
    
}

// MARK: -
// MARK: - Configure

extension CreateRecordViewController {

    private func configureCoordinator() {
        coordinator = CreateRecordControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CreateRecordControllerLayoutManager(vc: self)
    }
    
}
