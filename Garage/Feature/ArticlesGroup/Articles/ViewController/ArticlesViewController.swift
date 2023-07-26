//
//  ArticlesViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 27.06.23.
//  
//

import UIKit

class ArticlesViewController: BasicViewController {

    // - UI
    typealias Coordinator = ArticlesControllerCoordinator
    typealias Layout = ArticlesControllerLayoutManager
    
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
        makeLogoNavbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(false)
        layout.table.table.reloadData()
    }
    
    override func singleWillAppear() {
        super.singleWillAppear()
        vm.readArticles()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        super.binding()
        layout.table.setViewModel(vm.tableVM)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cells in
                self?.layout.table.reload()
            }
            .store(in: &cancellables)
        
        vm.$isLoadingInProgress.sink { [weak self] value in
            guard let self else { return }
                layout.animationView.isHidden = !value
                value ? layout.animationView.play() : layout.animationView.pause()
        }
        .store(in: &cancellables)
    }
    
}

// MARK: -
// MARK: - Configure

extension ArticlesViewController {

    private func configureCoordinator() {
        coordinator = ArticlesControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = ArticlesControllerLayoutManager(vc: self)
    }
    
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articleVM = vm.tableVM.cells[safe: indexPath.row],
              let articleCell = tableView.dequeueReusableCell(BasicTableCell<ArticleView>.self)
        else { return .init() }
        articleVM.markAsReadIfNeeded()
        articleCell.mainView.setViewModel(articleVM)
        articleCell.selectionStyle = .none
        return articleCell
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleVM = vm.tableVM.cells[safe: indexPath.row] else { return }
        coordinator.navigateTo(ArticlesNavigationRoute.openArticle(articleVM.article))
    }
}
