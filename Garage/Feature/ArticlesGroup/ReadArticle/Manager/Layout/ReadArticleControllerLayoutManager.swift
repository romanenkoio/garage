//
//  ReadArticleControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 28.06.23.
//  
//

import UIKit
import SnapKit

final class ReadArticleControllerLayoutManager {
    
    private unowned let vc: ReadArticleViewController
    
    private var mainStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.edgeInsets = .init(top: 20, horizontal: 20)
        return stack
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "test_article")
        view.cornerRadius = 20
        return view
    }()
    
    private(set) lazy var title: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 24, weight: .black)
        label.textInsets = .init(top: 10, bottom: 10, horizontal: 8)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var textLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .medium)
        label.textInsets = .init(top: 10, bottom: 10, horizontal: 8)
        label.numberOfLines = 0
        label.textColor = UIColor(hexString: "#626262")
        return label
    }()
    
    // - Init
    init(vc: ReadArticleViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension ReadArticleControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(mainStack)
        mainStack.addArrangedSubviews([
            imageView,
            title,
            textLabel
        ])
    }
    
    private func makeConstraint() {
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
}
