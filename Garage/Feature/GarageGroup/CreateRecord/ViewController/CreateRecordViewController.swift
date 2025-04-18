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
        layout.dateInput.setViewModel(vm.dateInputVM)
        layout.costInput.setViewModel(vm.costInputVM)
        layout.mileageImput.setViewModel(vm.mileageInputVM)
        layout.imageList.setViewModel(vm.imagePickerVM)
        layout.saveButton.setViewModel(vm.saveButtonVM)
        layout.servicesList.setViewModel(vm.serivesListVM)
        layout.shortTypeInput.setViewModel(vm.shortTypeVM)
        layout.commentInput.setViewModel(vm.commenntInputVM)
        
        vm.$services.sink { [weak self] items in
            self?.layout.servicesList.isHidden = items.isEmpty
        }
        .store(in: &cancellables)
        
        vm.saveButtonVM.buttonVM.action = .touchUpInside { [weak self] in
            guard let self else { return }
            self.vm.action()
            self.coordinator.navigateTo(CommonNavigationRoute.close)
        }
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
