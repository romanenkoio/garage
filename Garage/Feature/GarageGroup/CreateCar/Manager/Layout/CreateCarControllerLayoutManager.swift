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
    
    lazy var carImage = CarImageSelector()
    
    lazy var fieldStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.edgeInsets = .init(top: 21, horizontal: 21)
        return stack
    }()
    
    lazy var brandField: BasicInputView = {
        let field = BasicInputView()
        field.tag = 1
        return field
    }()
    
    lazy var modelField: BasicInputView = {
        let field = BasicInputView()
        field.tag = 2
        return field
    }()
    
    lazy var winField: BasicInputView = {
        let field = BasicInputView()
        field.tag = 0
        return field
    }()
    
    lazy var yearField: BasicInputView = {
        let field = BasicInputView()
        field.textField.setMode(.digit)
        field.tag = 3
        return field
    }()
    
    lazy var mileageField: BasicInputView = {
        let field = BasicInputView()
        field.textField.setMode(.digit)
        field.tag = 4
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
            carImage,
            winField,
            brandField,
            modelField,
            mileageField,
            yearField,
            saveButton
        ])
    }
    
    private func makeConstraint() {
        fieldStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
