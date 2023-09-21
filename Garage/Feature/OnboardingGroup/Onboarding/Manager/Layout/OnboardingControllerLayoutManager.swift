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
    
    
    private(set) lazy var page: UIPageControl = {
       let page = UIPageControl()
        page.numberOfPages = vc.vm.collectionVM.cells.count
        page.currentPage = 0
        page.currentPageIndicatorTintColor = AppColors.blue
        page.pageIndicatorTintColor = AppColors.fieldBg
        page.isUserInteractionEnabled = false
        return page
    }()
    
    private(set) lazy var skipLabel: TappableLabel = {
        let label = TappableLabel()
        label.font = .custom(size: 12, weight: .medium)
        label.textColor = AppColors.tabbarIcon
        label.textInsets = UIEdgeInsets(horizontal: 8)
        return label
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
            self?.page.currentPage = path.row
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
        vc.contentView.addSubview(page)
        vc.contentView.addSubview(skipLabel)
    }
    
    private func makeConstraint() {
        skipLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(skipLabel.snp.bottom).offset(-3)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(page.snp.top)
        }
        
        page.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualTo(collectionView.snp.bottom)
            make.bottom.equalTo(nextButton.snp.top).offset(-15)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}
