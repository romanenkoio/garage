//
//  FAQViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 11.09.23.
//  
//

import UIKit

class FAQViewController: BasicViewController {

    // - UI
    
    
    // - Property
    private(set) var vm: ViewModel?
    
    // - Manager
    private var coordinator: FAQControllerCoordinator!
    private var layoutManager: FAQControllerLayoutManager!
    
    init(vm: ViewModel) {
        super.init()
        self.vm = vm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeCloseButton(side: .left)
        title = "Периоды ТО"
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension FAQViewController {
    
    private func configureCoordinator() {
        coordinator = FAQControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layoutManager = FAQControllerLayoutManager(vc: self)
    }
    
}
