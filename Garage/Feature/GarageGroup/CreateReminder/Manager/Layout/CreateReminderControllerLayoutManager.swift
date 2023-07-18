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
        stack.addArrangedSubview([
            (shortTypeInput, spacing: 6),
            (SeparatorView(), spacing: 24),
            (dateInput, spacing: 24),
            (SeparatorView(), spacing: 24),
            (commentInput, spacing: 20),
            (saveButton, spacing: 0)
        ])

    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
