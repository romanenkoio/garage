//
//  ArticlesControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 27.06.23.
//  
//

import UIKit
import SnapKit
import Lottie

final class ArticlesControllerLayoutManager {
    
    private unowned let vc: ArticlesViewController
    
    lazy var table: BasicTableView = {
       let table = BasicTableView()
        table.setupTable(dataSource: vc, delegate: vc)
        table.register(BasicTableCell<ArticleView>.self)
        table.table.separatorStyle = .none
        table.table.contentInset = .init(top: 15)
        return table
    }()
    
    
    lazy var animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        let animation = LottieAnimation.named("loader.json", animationCache: DefaultAnimationCache.sharedCache)
        view.animation = animation
        view.animationSpeed = 1
        view.loopMode = .loop
        return view
    }()
    
    // - Init
    init(vc: ArticlesViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension ArticlesControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.disableScrollView()
        vc.contentView.addSubview(table)
        vc.contentView.addSubview(animationView)
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-50)
            make.height.width.equalTo(200)
        }
    }
    
}
