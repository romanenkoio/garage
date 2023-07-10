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
    
    lazy var container: BasicView = {
        let view = BasicView()
        view.backgroundColor = .clear
        view.cornerRadius = 0
        return view
    }()

    lazy var typeField = SuggestionInput<DocumentType>()
    lazy var separator = SeparatorView()
    lazy var datePicker = RangeDatePicker()
    lazy var separator2 = SeparatorView()
    lazy var imageList = BasicImageListView()
    lazy var saveButton = AlignedButton()
    
    // - Init
    init(vc: CreateDocumentViewController) {
        self.vc = vc
        configure()
        vc.makeCloseButton()
    }
    
    deinit {
        print("deinit CreateDocumentControllerLayoutManager")
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
        vc.contentView.addSubview(container)
        
        container.addSubview(typeField)
        container.addSubview(separator)
        container.addSubview(datePicker)
        container.addSubview(separator2)
        container.addSubview(imageList)
        container.addSubview(saveButton)
    }
    
    private func makeConstraint() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 21, horizontal: 21))
        }
        
        typeField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(typeField.snp.bottom).offset(12)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(32)
        }
        
        separator2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(datePicker.snp.bottom).offset(32)
        }
        
        imageList.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(separator2.snp.bottom).offset(32)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageList.snp.bottom).offset(32)
            make.bottom.equalToSuperview()
        }
    }
}
