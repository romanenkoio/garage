//
//  FullSizePhotoControllerViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 12.06.23.
//  
//

import UIKit

class FullSizePhotoViewController: BasicViewController {

    // - UI
    typealias Coordinator = FullSizePhotoControllerCoordinator
    lazy var collectionView: BasicCollectionView = {
        let collection = BasicCollectionView()
        collection.setupCollection(
            dataSource: self,
            delegate: self
        )
        collection.register(PhotoCell.self)
        return collection
    }()
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init()
        collectionView.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        disableScrollView()
    }

    override func configure() {
        configureCoordinator()
    }
    
    override func layoutElements() {
        contentView.addSubview(collectionView)
    }

    override func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func binding() {
        collectionView.setViewModel(vm.collectionVM)
    }
    
}

// MARK: - CollectionViewDataSource

extension FullSizePhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.collectionVM.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = collectionView.dequeueReusableCell(PhotoCell.self, for: indexPath),
              let item = vm.collectionVM.cells[safe: indexPath.row]
        else { return .init()}
        photoCell.mainView.setViewModel(.init(image: item))
        return photoCell
    }
    
}

// MARK: - CollectionViewDelegateFlowLayout

extension FullSizePhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200)
    }
}

// MARK: -
// MARK: - Configure

extension FullSizePhotoViewController {

    private func configureCoordinator() {
        coordinator = FullSizePhotoControllerCoordinator(vc: self)
    }
}
