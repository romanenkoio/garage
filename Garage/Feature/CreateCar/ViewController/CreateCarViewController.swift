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
    private(set) var coordinator: Coordinator!
    private var layout: Layout!
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init()
        title = "Добавить машину"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar(false)
        setupNavBar()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    private func setupNavBar() {
        makeCloseButton(isLeft: true)
        
        guard case .edit(_) = vm.mode else {
          return
        }

        let deleteButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                let vm = Popup.ViewModel(titleVM: .init(text: "Вы уверены, что хотите удалить машину?"))
                vm.confirmButton.action = .touchUpInside { [weak self] in
                    self?.vm.removeCar()
                }
                self?.coordinator.navigateTo(CommonNavigationRoute.confirmPopup(vm: vm))
            },
            image: UIImage(named: "delete_ic")
        )
        makeRightNavBarButton(buttons: [deleteButton])
    }
    
    override func binding() {
        super.binding()
        layout.brandField.setViewModel(vm.brandFieldVM)
        layout.modelField.setViewModel(vm.modelFieldVM)
        layout.winField.setViewModel(vm.winFieldVM)
        layout.yearField.setViewModel(vm.yearFieldVM)
        layout.mileageField.setViewModel(vm.mileageFieldVM)
        layout.saveButton.setViewModel(vm.saveButtonVM)
        
        vm.isLoadind.sink { [weak self] value in
            value ? self?.startLoader() : self?.stopLoader()
        }
        .store(in: &cancellables)
        
        vm.succesCreateCompletion = { [weak self] in
            self?.coordinator.navigateTo(CommonNavigationRoute.close)
        }
        
        vm.suggestionCompletion = { [weak self] items in
            let vm = SelectionViewController.ViewModel(cells: items)

            vm.selectionSuccess = { [weak self] selectedItem in
                if let selected = selectedItem as? Brand {
                    self?.vm.brandFieldVM.text = selected.name
                    self?.vm.modelFieldVM.actionImageVM?.isEnabled = true
                    self?.vm.modelFieldVM.text = .empty
                } else if let seleted = selectedItem as? Model {
                    self?.vm.modelFieldVM.text = seleted.modelName
                }
                self?.dismiss(animated: true)
            }
           
            self?.coordinator.navigateTo(CreateCarNavigationRoute.selectSuggestion(vm))
        }
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
