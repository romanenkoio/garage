//
//  CreateServiseControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//  
//

import UIKit
import SnapKit

final class CreateServiseControllerLayoutManager {
    
    private unowned let vc: CreateServiseViewController
    
    lazy var nameInput = BasicInputView()
    lazy var specialisationInput = BasicInputView()
    lazy var adressInput = BasicInputView()
    lazy var saveButton = AlignedButton()
    lazy var commentInput = MultiLineInput()
    
    lazy var phoneInput: BasicInputView = {
        let field = BasicInputView()
        field.textField.setMode(.phone)
        return field
    }()

    lazy var fieldStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.paddingInsets = UIEdgeInsets(horizontal: 21)
        return stack
    }()

    // - Init
    init(vc: CreateServiseViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CreateServiseControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(fieldStack)
        fieldStack.addArrangedSubviews([
            nameInput,
            phoneInput,
            specialisationInput,
            adressInput,
            commentInput,
            saveButton
        ])
    }
    
    private func makeConstraint() {
        fieldStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 22))
        }
    }
    
}
