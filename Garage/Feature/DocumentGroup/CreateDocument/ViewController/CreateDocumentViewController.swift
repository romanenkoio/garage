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
    
    deinit {
        print("deinit CreateDocumentViewController")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    private func setupNavBar() {
        makeCloseButton(isLeft: true)
        
        guard case .edit(_) = vm.mode else {
            title = "Добавление документа"
            return
        }
        
        let deleteButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                let vm = Dialog.ViewModel(title: .text("Вы уверены, что хотите удалить документ?"))  { [weak self] in
                    self?.vm.removeDocument() { [weak self] in
                        self?.coordinator.navigateTo(CommonNavigationRoute.close)
                    }
                }
                self?.coordinator.navigateTo(CommonNavigationRoute.confirmPopup(vm: vm))
            },
            image: UIImage(named: "delete_ic")
        )
        makeRightNavBarButton(buttons: [deleteButton])
        title = "Изменение документа"
    }

    override func binding() {
        layout.typeField.setViewModel(vm.typeFieldVM)
        layout.datePicker.setViewModel(vm.datePickerVM)
        layout.saveButton.setViewModel(vm.saveButtonVM)
        layout.imageList.setViewModel(vm.imageListVM)
        
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
