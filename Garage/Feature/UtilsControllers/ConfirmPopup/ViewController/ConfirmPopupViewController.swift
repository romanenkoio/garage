//
//  ConfirmPopupViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 23.06.23.
//  
//

import UIKit

class ConfirmPopupViewController: BasicViewController {

    // - UI
    typealias Coordinator = ConfirmPopupControllerCoordinator
    typealias Layout = ConfirmPopupControllerLayoutManager
    
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
        disableScrollView()
        setupGestures()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.confirmLabel.setViewModel(vm.confirmLabelVM)
        layout.confirmButton.setViewModel(vm.confirmButton)
        layout.cancelButton.setViewModel(vm.cancelButton)
        
        vm.cancelButton.action = .touchUpInside { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        self.contentView.addGestureRecognizer(tap)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
}

// MARK: -
// MARK: - Configure

extension ConfirmPopupViewController {

    private func configureCoordinator() {
        coordinator = ConfirmPopupControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = ConfirmPopupControllerLayoutManager(vc: self)
    }
    
}
