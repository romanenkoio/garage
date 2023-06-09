//
//  CreateRepairControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 10.06.23.
//  
//

import UIKit
import SnapKit

final class CreateRepairControllerLayoutManager {
    
    private unowned let vc: CreateRepairViewController
    
    lazy var fieldStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    lazy var carField = BasicInputView()
    lazy var serviseField = BasicInputView()
    lazy var costField = BasicInputView()
    lazy var mileageField = BasicInputView()
    lazy var datePicker = BasicDatePicker()
    lazy var saveButton = BasicButton()
    
    // - Init
    init(vc: CreateRepairViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CreateRepairControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(fieldStack)
        fieldStack.addArrangedSubviews([
            carField,
            serviseField,
            costField,
            mileageField,
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
