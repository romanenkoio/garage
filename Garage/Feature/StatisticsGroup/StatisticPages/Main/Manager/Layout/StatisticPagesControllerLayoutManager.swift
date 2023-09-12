//
//  MainControllerLayoutManager.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 28.08.23.
//  
//

import UIKit
import SnapKit

final class StatisticPagesControllerLayoutManager {
    
    private unowned let vc: StatisticPagesViewController
    
    // - UI
    private(set) lazy var segment: BasicSegmentView<StatisticType> = {
        let view = BasicSegmentView<StatisticType>()
        view.backgroundColor = .white
        return view
    }()
    
    private(set) lazy var page = BasicPageController(vm: vc.vm.pageVM)
    
    // - Init
    init(vc: StatisticPagesViewController) {
        self.vc = vc
        configure()
    }
}

// MARK: -
// MARK: - Configure

fileprivate extension StatisticPagesControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(segment)
        vc.contentView.addSubview(page.view)
        vc.addChild(page)
        page.didMove(toParent: vc)
    }
    
    private func makeConstraint() {
        segment.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        page.view.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
