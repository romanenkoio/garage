//
//  MultiLineInput.swift
//  Garage
//
//  Created by Illia Romanenko on 20.06.23.
//

import UIKit

class MultiLineInput: BasicView {
    
    private lazy var input: BasicTextView = {
        let input = BasicTextView()
        input.font = .custom(size: 17, weight: .medium)
        return input
    }()
    
    private lazy var descriptionLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .left
        label.font = .custom(size: 14, weight: .bold)
        label.textColor = .primaryBlue
        return label
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        return view
    }()
    
    private lazy var topStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
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
    
    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()

        return didBecomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        vm?.inputVM.validate()
        return didResignFirstResponder
    }

    private(set) weak var vm: ViewModel?
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func setup() {
        layer.cornerRadius = 12
        layer.borderColor = UIColor.secondaryGray.cgColor
        backgroundColor = .clear
        layer.borderWidth = 1
    }
    
    private func makeLayout() {
        addSubview(errorView)
        addSubview(input)
        addSubview(topStack)
        topStack.addArrangedSubviews([descriptionLabel, requiredLabel])
        errorView.isHidden = true
    }
    
    private func makeConstraint() {
        topStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        input.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topStack.snp.bottom).offset(4)
            make.height.equalTo(118)
        }
        
        errorView.snp.makeConstraints { make in
            make.top.equalTo(input.snp.bottom).offset(9)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.vm = vm
        if let errorVM = vm.errorVM {
            self.errorView.setViewModel(vm: errorVM)
        }
        self.descriptionLabel.setViewModel(vm.descriptionLabelVM)
        self.requiredLabel.setViewModel(vm.requiredLabelVM)
        self.input.setViewModel(vm.inputVM)
        self.vm?.$isRequired.sink(receiveValue: { [weak self] value in
            self?.requiredLabel.isHidden = !value
        })
        .store(in: &cancellables)
    }
}
