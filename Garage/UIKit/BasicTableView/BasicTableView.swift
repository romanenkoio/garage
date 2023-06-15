//
//  BasicTableView.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//

import UIKit

class BasicTableView: BasicView {
    lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = true
        table.backgroundColor = .clear
        return table
    }()
    
    private lazy var emptyStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private lazy var emptyLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .center
        label.font = .custom(size: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var emptySubLabel: BasicLabel = {
        let label = BasicLabel()
        label.textColor = .textGray
        label.font = .custom(size: 14, weight: .medium)
        label.textInsets = .init(bottom: 30)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var addButton = BasicButton()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        addSubview(table)
        addSubview(emptyStack)
        emptyStack.addArrangedSubviews([
            emptyImageView,
            emptyLabel,
            emptySubLabel,
            addButton
        ])
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.height.equalTo(117)
            make.width.equalTo(276)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        emptyLabel.setViewModel(vm.labelVM)
        emptySubLabel.setViewModel(vm.subLabelVM)
        addButton.setViewModel(vm.addButtonVM)
        
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
