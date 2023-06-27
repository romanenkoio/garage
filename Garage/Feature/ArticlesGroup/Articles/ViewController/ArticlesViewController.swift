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
        guard let article = vm.tableVM.cells[safe: indexPath.row],
              let articleCell = tableView.dequeueReusableCell(BasicTableCell<ArticleView>.self)
        else { return .init() }
        articleCell.mainView.setViewModel(.init(title: article.title, image: nil))
        articleCell.selectionStyle = .none
        return articleCell
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = vm.tableVM.cells[safe: indexPath.row] else { return }
        coordinator.navigateTo(ArticlesNavigationRoute.openArticle(article))
    }
}
