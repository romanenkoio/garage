//
//  CreateCarViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

class CreateCarViewController: BasicViewController {

    // - UI
    typealias Coordinator = CreateCarControllerCoordinator
    typealias Layout = CreateCarControllerLayoutManager
    
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
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.brandField.setViewModel(vm.brandFieldVM)
        layout.modelField.setViewModel(vm.modelFieldVM)
        layout.winField.setViewModel(vm.winFieldVM)
        layout.yearField.setViewModel(vm.yearFieldVM)
        layout.mileageField.setViewModel(vm.mileageFieldVM)
        layout.generationField.setViewModel(vm.generationFieldVM)
        layout.saveButton.setViewModel(vm.saveButtonVM)
    }
}

// MARK: -
// MARK: - Configure

extension CreateCarViewController {

    private func configureCoordinator() {
        coordinator = CreateCarControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CreateCarControllerLayoutManager(vc: self)
    }
    
}
