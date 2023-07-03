//
//  ReadArticleViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 28.06.23.
//  
//

import UIKit

class ReadArticleViewController: BasicViewController {

    // - UI
    typealias Coordinator = ReadArticleControllerCoordinator
    typealias Layout = ReadArticleControllerLayoutManager
    
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
        hideTabBar(true)
        makeCloseButton(isLeft: true)
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.title.setViewModel(vm.titleVM)
        layout.textLabel.setViewModel(vm.textVM)
        title = vm.titleVM.text
    }
    
}

// MARK: -
// MARK: - Configure

extension ReadArticleViewController {

    private func configureCoordinator() {
        coordinator = ReadArticleControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = ReadArticleControllerLayoutManager(vc: self)
    }
    
}
