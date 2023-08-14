//
//  ConfirmPopupControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 23.06.23.
//  
//

import UIKit
import SnapKit

typealias Dialog = ConfirmPopupViewController

final class ConfirmPopupControllerLayoutManager {
    
    private unowned let vc: ConfirmPopupViewController
    
    private lazy var mainStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.cornerRadius = 30
        stack.backgroundColor = .white
        stack.paddingInsets = .init(vertical: 16, horizontal: 32)
        stack.edgeInsets = .init(horizontal: 20)
        return stack
    }()
    
    private(set) lazy var confirmLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textInsets = .init(top: 8, bottom: 5)
        label.font = .custom(size: 18, weight: .bold)
        return label
    }()
    
    private(set) lazy var subtitleLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = AppColors.subtitle
        label.textInsets = .init(top: 5, bottom: 12)
        label.font = .custom(size: 14, weight: .bold)
        return label
    }()
    
    private lazy var buttonStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.edgeInsets = .init(top: 20)
        stack.spacing = 8
        return stack
    }()
    
    private(set) lazy var imageView = BasicImageView()
    
    private(set) lazy var confirmButton = BasicButton()
    private(set) lazy var cancelButton = BasicButton()
    
    // - Init
    init(vc: ConfirmPopupViewController) {
        self.vc = vc
        configure()
    }
}

// MARK: -
// MARK: - Configure

fileprivate extension ConfirmPopupControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.view.backgroundColor = .black.withAlphaComponent(0.29)
        vc.contentView.backgroundColor = .clear
        self.vc.contentView.addSubview(mainStack)
        let view = UIView()
        view.addSubview(imageView)
        mainStack.addArrangedSubviews([view, confirmLabel, subtitleLabel, buttonStack])
        buttonStack.addArrangedSubviews([cancelButton, confirmButton])
    }
    
    private func makeConstraint() {
        mainStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.center.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
}
