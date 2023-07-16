//
//  BasicTableView.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//

import UIKit

class BasicTableView: BasicView {
    private let style: UITableView.Style
    
    lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: style)
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
    
    init(style: UITableView.Style = .plain) {
        self.style = style
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        makeLayout()
        
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
    
    private func largeMakeConstraint() {
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
    
    private func smallMakeConstraints() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 40))
            make.top.equalToSuperview().offset(70)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.height.equalTo(67)
            make.width.equalTo(226)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        emptyLabel.setViewModel(vm.labelVM)
        emptySubLabel.setViewModel(vm.subLabelVM)
        addButton.setViewModel(vm.addButtonVM)
        
        vm.$isEmpty.receive(on: DispatchQueue.main).sink { [weak self] value in
            guard let self else { return }
            self.emptyStack.isHidden = !value
            self.table.isHidden = value
        }
        .store(in: &cancellables)
        
        vm.$image.sink { [weak self] image in
            self?.emptyImageView.image = image
        }
        .store(in: &cancellables)
        
        vm.$isHiddenButton.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.addButton.isHidden = value
        }
        .store(in: &cancellables)
        
        vm.$emptyViewType.sink {[weak self] type in
            if let type {
                switch type {
                    case .large:
                        self?.largeMakeConstraint()
                    case .small:
                        self?.smallMakeConstraints()
                }
            }
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
