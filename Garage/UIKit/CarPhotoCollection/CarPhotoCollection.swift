//
//  CarPhotoCollection.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.07.23.
//

import UIKit

class CarPhotoCollection: BasicView {
    lazy var collectionView: BasicCollectionView = {
        let layout = CarPhotoCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0.0
        layout.itemSize = CGSize(width: 278, height: 188)
        
        let collection = BasicCollectionView(layout: layout)
        collection.setupCollection(
            dataSource: self,
            delegate: self
        )
        collection.register(CarCellPhotoCell.self)
        collection.collection.contentInset = UIEdgeInsets(horizontal: 8)
        collection.collection.decelerationRate = UIScrollView.DecelerationRate.fast
        collection.collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = AppColors.darkGray
        pageControl.pageIndicatorTintColor = AppColors.lightGray
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private(set) var vm: ViewModel?
    
    override init() {
        super.init()
        makeLayout()
        makeConstraints()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(collectionView)
        addSubview(pageControl)
        collectionView.emptyLabel.removeFromSuperview()
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(188)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView.emptyStack.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIEdgeInsets(bottom: 25))
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        collectionView.setViewModel(vm.collectionVM)
    }
    
    private func findCenterIndex() {
        let center = self.convert(self.collectionView.collection.center, to: self.collectionView.collection)
        guard let index = collectionView.collection.indexPathForItem(at: center) else { return }

        pageControl.currentPage = index.row
    }
}

extension CarPhotoCollection: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let vm else { return 0}
        pageControl.numberOfPages = vm.images.count
        pageControl.isHidden = !(vm.images.count > 1)
        return vm.collectionVM.cells.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
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
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let vm else { return }
        let photoVC = FullSizePhotoViewController(vm: .init(images: vm.images, selectedIndex: indexPath.row))
        presentOnRootViewController(photoVC, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        findCenterIndex()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        findCenterIndex()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        findCenterIndex()
    }
}
