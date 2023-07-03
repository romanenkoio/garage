//
//  OnboardingControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 3.07.23.
//  
//

import UIKit
import SnapKit

final class OnboardingControllerLayoutManager {
    
    private unowned let vc: OnboardingViewController
    
    lazy var collectionView: BasicCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(all: 0)
        
        let collection = BasicCollectionView(layout: layout)
        collection.collection.bounces = false
        collection.collection.alwaysBounceHorizontal = false
        collection.collection.bouncesZoom = false
        collection.collection.showsHorizontalScrollIndicator = false
        collection.collection.showsVerticalScrollIndicator = false
        collection.collection.isPagingEnabled = true
        collection.collection.isScrollEnabled = false
        collection.register(BasicCollectionCell<OnboardingView>.self)
        collection.setupCollection(dataSource: vc, delegate: vc)
        return collection
    }()
    
   
    lazy var nextButton = AlignedButton()
     
    // - Init
    init(vc: OnboardingViewController) {
        self.vc = vc
        configure()
    }
}

// MARK: -
// MARK: - Configure

fileprivate extension OnboardingControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
        vc.disableScrollView()
        
        vc.vm.$currentPath.dropFirst().sink { [weak self] path in
            self?.collectionView.collection.scrollToItem(
                at: path,
                at: .right,
                animated: true)
        }
        .store(in: &vc.cancellables)
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(collectionView)
        vc.contentView.addSubview(nextButton)
    }
    
    private func makeConstraint() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(collectionView.snp.width).multipliedBy(1.575)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.greaterThanOrEqualTo(collectionView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
