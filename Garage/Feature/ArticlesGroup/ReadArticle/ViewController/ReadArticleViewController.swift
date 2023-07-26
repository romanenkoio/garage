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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        layout.progressView.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.bringButton()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.title.setViewModel(vm.titleVM)
        layout.textLabel.setViewModel(vm.textVM)
        layout.imageView.setViewModel(vm.imageVM)
        title = vm.titleVM.textValue.clearText
        layout.upButton.setViewModel(vm.upButtonVM)
        layout.progressView.setViewModel(vm.progressView)
        
        vm.upButtonVM.action = { [weak self] in
            self?.layout.scrollToTop()
        }
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

extension ReadArticleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height - scrollView.bounds.height
        let currentPosition = scrollView.contentOffset.y
        
        let percent = contentHeight / 100
        let result = currentPosition / percent
        layout.updateUpButton(progres: result)
        if result > 80 {
            vm.markAsRead()
        }
        self.vm.progressView.progress = result / 100
    }
}
