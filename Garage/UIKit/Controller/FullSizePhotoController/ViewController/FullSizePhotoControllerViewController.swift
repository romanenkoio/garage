//
//  FullSizePhotoControllerViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 12.06.23.
//  
//

import UIKit

class FullSizePhotoViewController: BasicModalPresentationController {

    // - UI
    typealias Coordinator = FullSizePhotoControllerCoordinator
    
    lazy var collectionView: BasicCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(all: 0)
       
        let collection = BasicCollectionView(layout: layout)
        collection.setupCollection(
            dataSource: self,
            delegate: self
        )
        collection.collection.bounces = true
        collection.collection.alwaysBounceHorizontal = true
        collection.collection.bouncesZoom = true
        collection.collection.showsHorizontalScrollIndicator = false
        collection.collection.showsVerticalScrollIndicator = false
        collection.collection.isPagingEnabled = true
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
        collectionView.backgroundColor = .black
        self.view.backgroundColor = .black
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
        contentView.isHidden = true
        view.addSubview(collectionView)
        view.bringSubviewToFront(collectionView)
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
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoCell = cell as? PhotoCell else { return }
        photoCell.mainView.scrollView.setZoomScale(1, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = view.frame.width
        let height = view.window?.screen.bounds.height ?? 0
        return CGSize(width: width, height: height)
    }
}

// MARK: -
// MARK: - Configure

extension FullSizePhotoViewController {
    private func configureCoordinator() {
        coordinator = FullSizePhotoControllerCoordinator(vc: self)
    }
}
