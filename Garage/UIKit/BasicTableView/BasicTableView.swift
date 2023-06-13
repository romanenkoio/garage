//
//  BasicTableView.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//

import UIKit

class BasicTableView: BasicView {
    private lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = true
        return table
    }()
    
    private lazy var emptyStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 30
        return stack
    }()
    
    private lazy var emptyLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        addSubview(table)
        addSubview(emptyStack)
        emptyStack.addArrangedSubviews([emptyImageView, emptyLabel])
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(UIScreen.main.bounds.width - 100)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        emptyLabel.setViewModel(vm.labelVM)
        
        vm.$isEmpty.sink { [weak self] value in
            guard let self else { return }
            self.emptyStack.isHidden = !value
            self.table.isHidden = value
        }
        .store(in: &cancellables)
        
        vm.$image.sink { [weak self] image in
            self?.emptyImageView.image = image
        }
        .store(in: &cancellables)
    }
    
    func setupTable(
        dataSource: UITableViewDataSource,
        delegate: UITableViewDelegate? = nil
    ) {
        table.dataSource = dataSource
        table.delegate = delegate
    }
    
    func register<T: UITableViewCell>(_ type: T.Type) {
        table.register(type)
    }
    
    func reload() {
        table.reloadData()
    }
}
