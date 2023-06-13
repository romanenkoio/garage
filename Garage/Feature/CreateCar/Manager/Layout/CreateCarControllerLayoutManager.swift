//
//  CreateCarControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import SnapKit

final class CreateCarControllerLayoutManager {
    
    private unowned let vc: CreateCarViewController
    
    lazy var fieldStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.edgeInsets = .init(top: 22)
        return stack
    }()
    
    lazy var brandField: BasicInputView = {
        let field = BasicInputView()
        return field
    }()
    
    lazy var modelField: BasicInputView = {
        let field = BasicInputView()
        return field
    }()
    
    lazy var winField: BasicInputView = {
        let field = BasicInputView()
        return field
    }()
    
    lazy var yearField: BasicInputView = {
        let field = BasicInputView()
        return field
    }()
    
    lazy var mileageField: BasicInputView = {
        let field = BasicInputView()
        return field
    }()
    
    lazy var saveButton = AlignedButton()

    // - Init
    init(vc: CreateCarViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CreateCarControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(fieldStack)
        fieldStack.addArrangedSubviews([
            winField,
            brandField,
            modelField,
            yearField,
            mileageField,
            saveButton
        ])
    }
    
    private func makeConstraint() {
        fieldStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
