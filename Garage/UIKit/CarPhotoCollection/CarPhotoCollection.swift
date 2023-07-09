//
//  CarPhotoCollection.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.07.23.
//

import UIKit

class CarPhotoCollection: BasicView {
    lazy var collectionView: BasicCollectionView = {
        let layot = UICollectionViewFlowLayout()
        layot.scrollDirection = .horizontal
        let collection = BasicCollectionView(layout: layot)
        collection.setupCollection(
            dataSource: self,
            delegate: self
        )
        collection.collection.isPagingEnabled = true
        collection.collection.bounces = true
        collection.register(CarCellPhotoCell.self)
        return collection
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    private(set) var vm: ViewModel?
    
    override init() {
        super.init()
        makeLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        collectionView.setViewModel(vm.collectionVM)
    }
}

extension CarPhotoCollection: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let vm else { return 0}
        return vm.collectionVM.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vm else { return .init()}
        guard let photoCell = collectionView.dequeueReusableCell(CarCellPhotoCell.self, for: indexPath),
              let item = vm.collectionVM.cells[safe: indexPath.row]
        else { return .init()}
        
        photoCell.mainView.setViewModel(
            .init(image: item)
        )
        return photoCell
    }
}

extension CarPhotoCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
