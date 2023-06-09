//
//  CreateDocumentControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//  
//

import UIKit
import SnapKit

final class CreateDocumentControllerLayoutManager {
    
    private unowned let vc: CreateDocumentViewController
    
    lazy var fieldStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    lazy var typeField = BasicInputView()
    lazy var datePicker = RangeDatePicker()
    lazy var saveButton = BasicButton()
    
    // - Init
    init(vc: CreateDocumentViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CreateDocumentControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(fieldStack)
        fieldStack.addArrangedSubviews([
            typeField,
            datePicker,
            saveButton
        ])
    }
    
    private func makeConstraint() {
        fieldStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
