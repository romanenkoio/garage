//
//  BasicSelectList.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import Foundation
import SnapKit
import Combine
import UIKit

class SuggestionInput<T: Equatable>: BasicInputView {
    typealias Item = T
    lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.edgeInsets = .horizintal
        stack.distribution = .fill
        return stack
    }()
    
    lazy var scrollStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.isHidden = true
        return stack
    }()
    
    private var itemViews: [SuggestionView] = []
    private(set) weak var viewModel: GenericViewModel<Item>?
    private var isOpen = false {
        didSet {
            animate()
        }
    }
    
    init() {
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
        textField.addTarget(self, action: #selector(endEdit), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(beginEdit), for: .editingDidBegin)
    }
    
    private func layoutElements() {
        addSubview(stack)
        stack.addArrangedSubviews([scrollStack])
        errorView.isHidden = true
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        scrollStack.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
        
        errorView.snp.remakeConstraints { make in
            make.top.equalTo(stack.snp.bottom).offset(2)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: GenericViewModel<Item>) {
        super.setViewModel(vm)
        self.viewModel = vm

        textField.attributedText = vm.placeholder.attributedString(
            font: .custom(size: 17, weight: .medium),
            textColor: .textBlack
        )
        
        vm.$items.sink { [weak self] items in
            self?.makeItems()
        }
        .store(in: &cancellables)
        
        vm.$selectedItem.sink { [weak self] item in
            self?.didSelectItem(item)
        }
        .store(in: &cancellables)
        
        vm.inputVM.isValidSubject.sink(receiveValue: { [weak self] value in
            self?.errorView.isHidden = value
        })
        .store(in: &cancellables)
        
        if let errorVM = vm.errorVM {
            self.errorView.setViewModel(vm: errorVM)
        }
        self.textField.setViewModel(vm: vm.inputVM)
    }
    
    
    private func didSelectItem(_ item: Item?) {
        guard let item else {
            self.textField.attributedText = vm?.placeholder.attributedString(
                font: .custom(size: 17, weight: .medium),
                textColor: .textLightGray)
            return
        }

        guard self.itemViews.count == self.viewModel?.items.count else { return }
        self.itemViews.enumerated().forEach { index, _ in
            if self.viewModel?.items[index] == item {
                self.textField.attributedText = viewModel?.titles[index].attributedString(
                    font: .custom(size: 17, weight: .medium),
                    textColor: .textBlack
                )
            }
        }
        self.isOpen = false
        _ = textField.resignFirstResponder()
    }
    
    private func makeItems() {
        guard let viewModel else { return }
        scrollStack.clearArrangedSubviews()
        self.itemViews.removeAll()
        viewModel.items.enumerated().forEach { [weak self] index, item in
            let view = SuggestionView()
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 8
            view.setViewModel(.init(labelVM: .init(
                .text(viewModel.titles[index]),
                action: { [weak self] in
                    self?.viewModel?.setSelected(item)
                }
            ), image: viewModel.icons[safe: index]))
            self?.scrollStack.addArrangedSubview(view)
            self?.itemViews.append(view)
        }
    }
    
    @objc private func beginEdit() {
        isOpen = true
        errorView.isHidden = true
    }
    
    @objc private func endEdit() {
        isOpen = false
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.3) {[weak self] in
            guard let self else { return }
            self.scrollStack.isHidden = !self.isOpen
            self.scrollStack.arrangedSubviews.forEach({$0.alpha = self.isOpen ? 1 : 0})
        } completion: {[weak self] isFinish in
            guard let self else { return }
            if !self.isOpen, isFinish, !self.errorView.isHidden {
                self.errorView.shake()
            }
        }
    }
}
