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
    }
    
    private func makeLayout() {
        contentView.addSubview(stack)
        stack.addArrangedSubviews([
            shortTypeInput,
            costInput,
            mileageImput
        ])
        
        contentView.addSubview(dateInput)
        contentView.addSubview(servicesList)
        contentView.addSubview(imageList)
        contentView.addSubview(commentInput)
        contentView.addSubview(saveButton)
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        dateInput.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
            make.top.equalTo(stack.snp.bottom).offset(10)
        }
        
        servicesList.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
            make.top.equalTo(dateInput.snp.bottom).offset(25)
        }
        
        imageList.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
            make.top.equalTo(servicesList.snp.bottom).offset(25)
        }
        
        commentInput.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
            make.top.equalTo(imageList.snp.bottom).offset(25)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
            make.top.equalTo(commentInput.snp.bottom).offset(25)
            make.bottom.equalToSuperview()
        }
    }
}
