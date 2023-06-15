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
    
    lazy private var navView = PhotoVcNavigationView()
    
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
        view.addSubview(navView)
        view.cornerRadius = 12
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
    
    override func binding() {
        collectionView.setViewModel(vm.collectionVM)
        
        navView.setViewModel(
            .init(
                closeButtonVM: .init(
                    title: "Закрыть",
                    style: .nonStyle,
                    action: .touchUpInside { [weak self] in
                        self?.dismiss(animated: true)
                    }
                )
            )
        )
        
        navView.setViewModel(
            .init(
                shareButtonVM: .init(
                    title: "Поделиться",
                    style: .nonStyle,
                    action: .touchUpInside { [self] in
                        share(sender: navView.shareButton)
                    }
                )
            )
        )
    }
    
    @objc func share(sender:UIView){

    }
    
    private func findCenterIndex() {
        let center = self.view.convert(self.collectionView.collection.center, to: self.collectionView.collection)
        guard let index = collectionView.collection.indexPathForItem(at: center) else { return }

        navView.setViewModel(.init(photoCountLabelVM: .init(text: "\(index.item+1) из \(vm.images.count)")))
    }
    
    //Придумать что-то с вьюМоделью navView и анимациями
    private func animate(with value: Bool) {
        UIView.transition(with: navView, duration: 0.3, options: .transitionCrossDissolve) {
            if value {
                
            } else {
               
            }
        }
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
        
        photoCell.mainView.setViewModel(
            .init(singleTapAction: {[weak self] in
                self?.navView.isHidden.toggle()
            },
                  zoomAction: {[weak self] in
                      self?.navView.isHidden = true
                  },
                  image: item
                 )
        )
        
        findCenterIndex()
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let index = vm.selectedIndex {
            let startSpecificIndexPath = IndexPath(item: index, section: 0)
            self.collectionView.collection.scrollToItem(at: startSpecificIndexPath, at: .centeredHorizontally, animated: false)
            vm.selectedIndex = nil
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        findCenterIndex()
    }
}

// MARK: -
// MARK: - Configure

extension FullSizePhotoViewController {
    private func configureCoordinator() {
        coordinator = FullSizePhotoControllerCoordinator(vc: self)
    }
}
