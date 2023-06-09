//
//  CreateDocumentViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//  
//

import UIKit

class CreateDocumentViewController: BasicViewController {

    // - UI
    typealias Coordinator = CreateDocumentControllerCoordinator
    typealias Layout = CreateDocumentControllerLayoutManager
    
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
        layout.typeField.setViewModel(vm.typeFieldVM)
        layout.datePicker.setViewModel(vm.datePickerVM)
        layout.saveButton.setViewModel(vm.saveButtonVM)
        
        vm.suggestionCompletion = { [weak self] items in
            let model = SelectionViewController.ViewModel(cells: items)
            
            model.selectionSuccess = { [weak self] selectedItem in
                self?.vm.typeFieldVM.text = selectedItem.title
                self?.dismiss(animated: true)
            }
            
            self?.coordinator.navigateTo(CreateDocumentNavigationRoute.selectSuggestion(model))
        }
        
        vm.saveCompletion = { [weak self] in
            self?.coordinator.navigateTo(CommonNavigationRoute.close)
        }
    }
    
}

// MARK: -
// MARK: - Configure

extension CreateDocumentViewController {

    private func configureCoordinator() {
        coordinator = CreateDocumentControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CreateDocumentControllerLayoutManager(vc: self)
    }
    
}
