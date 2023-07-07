//
//  CreateReminderControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 7.07.23.
//  
//

import UIKit
import SnapKit

final class CreateReminderControllerLayoutManager {
    
    private unowned let vc: CreateReminderViewController

    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.edgeInsets = UIEdgeInsets(top: 21, horizontal: 21)
        return stack
    }()
    
    lazy var shortTypeInput = SuggestionInput<ServiceType>()
    lazy var dateInput = BasicDatePicker()
    lazy var saveButton = AlignedButton()
    lazy var commentInput = MultiLineInput()

    var contentView: BasicView {
        return vc.contentView
    }
    
    // - Init
    init(vc: CreateReminderViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CreateReminderControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        contentView.addSubview(stack)
        stack.addArrangedSubviews([
            shortTypeInput,
            dateInput
        ])

        contentView.addSubview(commentInput)
        contentView.addSubview(saveButton)
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        commentInput.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
            make.top.equalTo(stack.snp.bottom).offset(20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
            make.top.equalTo(commentInput.snp.bottom).offset(25)
            make.bottom.equalToSuperview()
        }
    }
    
}
