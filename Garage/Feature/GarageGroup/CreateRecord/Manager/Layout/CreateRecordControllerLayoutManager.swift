//
//  CreateRecordControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 15.06.23.
//  
//

import UIKit
import SnapKit

final class CreateRecordControllerLayoutManager {
    
    private unowned let vc: CreateRecordViewController
    
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.edgeInsets = UIEdgeInsets(top: 21, horizontal: 21)
        return stack
    }()
    
    lazy var shortTypeInput = SuggestionInput<ServiceType>()
    lazy var costInput = BasicInputView()
    lazy var mileageImput = BasicInputView()
    lazy var dateInput = BasicDatePicker()
    lazy var imageList = BasicImageListView()
    lazy var saveButton = AlignedButton()
    lazy var servicesList = BasicList<Service>()
    lazy var commentInput = MultiLineInput()

    var contentView: BasicView {
        return vc.contentView
    }
    
    // - Init
    init(vc: CreateRecordViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CreateRecordControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
        mileageImput.textField.mode = .digit
        costInput.textField.mode = .digit
    }
    
    private func makeLayout() {
        contentView.addSubview(stack)
        stack.addArrangedSubview([
            (shortTypeInput, spacing: 0),
            (costInput, spacing: 0),
            (mileageImput, spacing: 0),
            (dateInput, spacing: 25),
            (servicesList, spacing: 25),
            (imageList, spacing: 25),
            (commentInput, spacing: 25),
            (saveButton, spacing: 0)
        ])
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
}
