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
    
    private(set) var mainStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.edgeInsets = .init(top: 20, horizontal: 20)
        return stack
    }()
    
    private(set) lazy var imageView: BasicImageView = {
        let view = BasicImageView()
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
    
    lazy var upButton: ActionImage = {
        let button = ActionImage()
        button.cornerRadius = 30
        button.alpha = 0
        return button
    }()
    
    lazy var progressView = ProgressView()
    
    // - Init
    init(vc: ReadArticleViewController) {
        self.vc = vc
        configure()
    }
    
    func scrollToTop() {
        self.vc.scroll.setContentOffset(.zero, animated: true)
    }
    
    func bringButton() {
        vc.view.bringSubviewToFront(upButton)
        upButton.alpha = 0
    }
    
    func updateUpButton(progres: CGFloat) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.upButton.alpha = progres > 20 ? 1 : 0
        }
    }
}

// MARK: -
// MARK: - Configure

fileprivate extension ReadArticleControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
        upButton.alpha = 0
        self.vc.scroll.delegate = vc
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(mainStack)
        vc.view.addSubview(upButton)
        mainStack.addArrangedSubviews([
            imageView,
            title,
            textLabel
        ])
        
        if let navBar = vc.navigationController?.navigationBar as? UIView {
            navBar.addSubview(progressView)
        }
    }
    
    private func makeConstraint() {
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }

        upButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(vc.view.safeAreaLayoutGuide).inset(UIEdgeInsets(bottom: 20, right: 20))
            make.height.width.equalTo(60)
        }
        
        progressView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
