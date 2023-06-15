//
//  BasicList.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 29.05.23.
//

import UIKit

class BasicList<T: Equatable>: BasicView {
    typealias Item = T
    
    private(set) var vm: GenericViewModel<Item>?
    
    private(set) var isOpen = false {
        didSet {
            animation()
        }
    }
    
    private var labels: [TappableLabel] = []
    
    private lazy var headerView: BasicView = {
        let view = BasicView()
        view.cornerRadius = 8
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.secondaryGray.cgColor

        return view
    }()
    
    private lazy var arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(arrowButtonDidTap), for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        return button
    }()
    
    private lazy var label: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 17, weight: .medium)
        label.textColor = .textBlack
        return label
    }()
    
    private lazy var listStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var itemStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.clipsToBounds = true
        stack.cornerRadius = 8
        stack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        stack.backgroundColor = .secondaryGray
        stack.paddingInsets = .init(vertical: 5, horizontal: 10)
        return stack
    }()
    
    override init() {
        super .init()
        makeLayout()
        makeConstraints()
        self.itemStack.isHidden = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(headerView)
        addSubview(listStack)
        
        headerView.addSubview(arrowButton)
        headerView.addSubview(label)
        
        listStack.addArrangedSubviews([itemStack])
    }
    
    private func makeConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.leading.trailing.equalToSuperview()
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(arrowButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        
        listStack.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        itemStack.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: GenericViewModel<Item>) {
        self.vm = vm
        vm.$title.sink { [weak self] value in
            self?.label.attributedText = value.attributedString(
                font: .custom(size: 17, weight: .medium),
                textColor: .textBlack
            )
        }
        .store(in: &cancellables)
        
        vm.$items.sink { [weak self] items in
            self?.makeItems()
        }
        .store(in: &cancellables)
        
        vm.$selectedItem.sink { [weak self] item in
            self?.makeSelection(item)
        }
        .store(in: &cancellables)
    }
    
    private func makeSelection(_ item: Item?) {
        guard let item else {
            self.label.attributedText = vm?.placeholder.attributedString(
                font: .custom(size: 17, weight: .medium),
                textColor: .textLightGray)
            return
        }

        guard self.labels.count == self.vm?.items.count else { return }
        self.labels.enumerated().forEach { index, label in
            if self.vm?.items[index] == item {
                label.layer.borderColor = UIColor.primaryBlue.cgColor
                self.label.attributedText = vm?.titles[index].attributedString(
                    font: .custom(size: 17, weight: .medium),
                    textColor: .textBlack
                )
            } else {
                label.layer.borderColor = UIColor.clear.cgColor
            }
        }
        self.isOpen = false
    }

    private func makeItems() {
        guard let vm else { return }
        itemStack.clearArrangedSubviews()
        self.labels.removeAll()
        vm.items.enumerated().forEach { [weak self] index, item in
            let label = TappableLabel(aligment: .left)
            label.layer.borderColor = UIColor.clear.cgColor
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 8
            label.font = .custom(size: 13, weight: .medium)
            label.textInsets = .init(vertical: 10, horizontal: 10)
            let labelVM = TappableLabel.ViewModel(text: vm.titles[index]) { [weak self] in
                self?.vm?.setSelected(item)
            }
          
            label.setViewModel(labelVM)
      
            self?.labels.append(label)
            self?.itemStack.addArrangedSubview(label)
        }
    }
    
    private func animation() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0.01,
            options: .preferredFramesPerSecond60) { [weak self] in
                guard let self else { return }
                self.itemStack.isHidden = !self.isOpen
                self.arrowButton.transform = self.isOpen ? CGAffineTransform(rotationAngle: .greatestFiniteMagnitude) : CGAffineTransform.identity
                self.headerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            } completion: { [weak self] isFinish in
                guard let self else { return }
                if !self.isOpen {
                    self.headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
                }
            }
        
        UIView.animate(withDuration: 0.3) {
            self.itemStack.arrangedSubviews.forEach({$0.alpha = self.isOpen ? 1 : 0})
        }
    }
    
    @objc private func arrowButtonDidTap() {
        isOpen.toggle()
    }
}
