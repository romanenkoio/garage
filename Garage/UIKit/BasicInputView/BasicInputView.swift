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

    lazy var actionImage: ActionImage = {
        let view = ActionImage()
        view.tintColor = .primaryPink
        return view
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
        addSubview(actionImage)
        errorView.isHidden = true
    }
    
    private func makeConstraints() {
        let textFieldInsets = UIEdgeInsets(left: 16, right: 16)
        textField.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(textFieldInsets)
        }
        
        let errorViewInsets = UIEdgeInsets(left: 16, right: 16)
        errorView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(5)
            make.leading.bottom.trailing.equalToSuperview().inset(errorViewInsets)
        }
        
        actionImage.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(textField).inset(UIEdgeInsets(all: 5))
            make.width.equalTo(actionImage.snp.height)
        }
    }
    
    func setViewModel(_ vm: ViewModel?) {
        guard let vm else { return }
        self.vm = vm
        self.errorView.setViewModel(vm: vm.errorVM)
        self.textField.setViewModel(vm: vm.inputVM)
        if let actionVM = vm.actionImageVM {
            self.actionImage.setViewModel(actionVM)
            self.actionImage.isHidden = false
        } else {
            self.actionImage.isHidden = true
        }
        
        self.vm?.inputVM.isValidSubject.dropFirst().sink(receiveValue: { [weak self] value in
            self?.errorView.isHidden = value
            self?.errorView.shake()
        })
        .store(in: &cancellables)
    }
}
