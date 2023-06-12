//
//  BasicCollectionView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 12.06.23.
//

import UIKit

class BasicCollectionView: BasicView {
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = true
        return collection
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
        addSubview(collection)
        addSubview(emptyStack)
        emptyStack.addArrangedSubviews([emptyImageView, emptyLabel])
    }
    
    private func makeConstraint() {
        collection.snp.makeConstraints { make in
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
            self.collection.isHidden = value
        }
        .store(in: &cancellables)
        
        vm.$image.sink { [weak self] image in
            self?.emptyImageView.image = image
        }
        .store(in: &cancellables)
    }
    
    func setupCollection(
        dataSource: UICollectionViewDataSource,
        delegate: UICollectionViewDelegate? = nil
    ) {
        collection.dataSource = dataSource
        collection.delegate = delegate
    }
    
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        collection.register(type)
    }
    
    func reload() {
        collection.reloadData()
    }
}
