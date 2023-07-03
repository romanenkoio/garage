//
//  ConfirmPopupControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 23.06.23.
//  
//

import UIKit
import SnapKit

typealias Popup = ConfirmPopupViewController

final class ConfirmPopupControllerLayoutManager {
    
    private unowned let vc: ConfirmPopupViewController
    
    private lazy var mainStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.cornerRadius = 30
        stack.backgroundColor = .white
        stack.paddingInsets = .init(vertical: 32, horizontal: 32)
        stack.edgeInsets = .init(horizontal: 20)
        return stack
    }()
    
    private(set) lazy var confirmLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .custom(size: 18, weight: .bold)
        return label
    }()
    
    private lazy var buttonStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
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
        mainStack.addArrangedSubviews([confirmLabel, buttonStack])
        buttonStack.addArrangedSubviews([cancelButton, confirmButton])
    }
    
    private func makeConstraint() {
        mainStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
}
