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
        stack.spacing = 16
        stack.edgeInsets = UIEdgeInsets(top: 21, horizontal: 21)
        return stack
    }()
    
    lazy var costInput = BasicInputView()
    lazy var mileageImput = BasicInputView()
    lazy var dateInput = BasicDatePicker()
    lazy var imageList = BasicImageListView()
    lazy var saveButton = AlignedButton()
    lazy var servicesList = BasicList<Service>()
    
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
    }
    
    private func makeLayout() {
        contentView.addSubview(stack)
        stack.addArrangedSubviews([
            costInput,
            mileageImput,
            dateInput,
            servicesList,
            imageList,
            saveButton
        ])
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
