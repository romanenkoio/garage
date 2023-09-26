//
//  CreateFuelRecordControllerLayoutManager.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 26.09.23.
//  
//

import UIKit
import SnapKit

final class CreateFuelRecordControllerLayoutManager {
    
    private unowned let vc: CreateFuelRecordViewController
    
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.edgeInsets = UIEdgeInsets(top: 21, horizontal: 21)
        return stack
    }()
    
    // - UI
    lazy var qauntityInput = BasicInputView(mode: .amount(rightLabel: "л"))
    lazy var costInput = BasicInputView(mode: .amount(rightLabel: .empty.appendCurrency()))
    lazy var dateInput = BasicDatePicker()
    lazy var saveButton = AlignedButton()
    
    var contentView: BasicView {
        return vc.contentView
    }
    
    // - Init
    init(vc: CreateFuelRecordViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CreateFuelRecordControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        contentView.addSubview(stack)
        stack.addArrangedSubview([
            (qauntityInput, spacing: 5),
            (costInput, spacing: 5),
            (dateInput, spacing: 25),
            (saveButton, spacing: 0)
        ])
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
