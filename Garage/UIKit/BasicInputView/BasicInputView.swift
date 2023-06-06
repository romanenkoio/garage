//
//  ValidationTextFieldView.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 17.05.23.
//

import UIKit
import SnapKit
import Combine

class BasicInputView: BasicView {
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        return view
    }()
    
    lazy var textField: BasicTextField = {
        let textField = BasicTextField()
        return textField
    }()

    private(set) weak var vm: ViewModel?

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        super.initView()
        backgroundColor = .clear
        layoutElements()
        makeConstraints()
    }
    
    private func layoutElements() {
        addSubview(errorView)
        addSubview(textField)
    }
    
    private func makeConstraints() {
        let textFieldInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        textField.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(textFieldInsets)
        }
        
        let errorViewInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        errorView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(5)
            make.leading.bottom.trailing.equalToSuperview().inset(errorViewInsets)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        self.errorView.setViewModel(vm: vm.errorVM)
        self.textField.setViewModel(vm: vm.inputVM)
        
        self.vm?.inputVM.isValidSubject.sink(receiveValue: { [weak self] value in
            self?.errorView.isHidden = value
            self?.errorView.shake()
        })
        .store(in: &cancellables)
    }
}
