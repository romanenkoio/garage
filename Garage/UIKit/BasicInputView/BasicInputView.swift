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
    lazy var errorView: ErrorView = {
        let view = ErrorView()
        return view
    }()
    
    lazy var textField: BasicTextField = {
        let textField = BasicTextField()
        return textField
    }()
    
    lazy var actionImage: ActionImage = {
        let view = ActionImage()
        view.tintColor = .primaryBlue
        return view
    }()
    
    private lazy var topStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.paddingInsets = .horizintal
        stack.edgeInsets = .init(bottom: 4)
        return stack
    }()
    
    lazy var requiredLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .right
        label.font = .custom(size: 11, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var descriptionLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .left
        label.font = .custom(size: 14, weight: .bold)
        label.textColor = .primaryBlue
        return label
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
        addSubview(topStack)
        topStack.addArrangedSubviews([descriptionLabel, requiredLabel])
        errorView.isHidden = true
    }
    
    private func makeConstraints() {
        let textFieldInsets = UIEdgeInsets(left: 16, right: 16)
        topStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(textFieldInsets)
            make.top.equalTo(topStack.snp.bottom)
        }
        
        let errorViewInsets = UIEdgeInsets(left: 16, right: 16)
        errorView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(2)
            make.leading.bottom.trailing.equalToSuperview().inset(errorViewInsets)
        }
        
        actionImage.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(textField).inset(UIEdgeInsets(all: 10))
            make.width.equalTo(actionImage.snp.height)
        }
    }
    
    func setViewModel(_ vm: ViewModel?) {
        guard let vm else { return }
        self.vm = vm
        if let errorVM = vm.errorVM {
            self.errorView.setViewModel(vm: errorVM)
        }
        self.descriptionLabel.setViewModel(vm.descriptionLabelVM)
        self.requiredLabel.setViewModel(vm.requiredLabelVM)
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
        
        self.vm?.$isRequired.sink(receiveValue: { [weak self] value in
            self?.requiredLabel.isHidden = !value
        })
        .store(in: &cancellables)
    }
}
