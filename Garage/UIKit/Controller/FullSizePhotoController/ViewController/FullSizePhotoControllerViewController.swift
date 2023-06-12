//
//  FullSizePhotoControllerViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 12.06.23.
//  
//

import UIKit

class FullSizePhotoControllerViewController: BasicViewController {

    // - UI
    typealias Coordinator = FullSizePhotoControllerControllerCoordinator
    lazy var collectionView: BasicCollectionView = {
        let collection = BasicCollectionView()
        collection.setupCollection(
            dataSource: self,
            delegate: self
        )
        collection.register(<#T##type: T.Type##T.Type#>)
        return collection
    }()
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
    
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
    }

    override func configure() {
        configureCoordinator()
    }

    override func binding() {
        
    }
    
}

// MARK: - CollectionViewDataSource

extension FullSizePhotoControllerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}

// MARK: - CollectionViewDelegateFlowLayout

extension FullSizePhotoControllerViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: -
// MARK: - Configure

extension FullSizePhotoControllerViewController {

    private func configureCoordinator() {
        coordinator = FullSizePhotoControllerControllerCoordinator(vc: self)
    }
}
