//
//  BasicSegmentView.swift
//  Logogo
//
//  Created by Illia Romanenko on 22.05.23.
//

import Foundation
import Combine
import UIKit

class BasicSegmentView<T: Equatable>: BasicView {
    typealias Item = T

    private(set) var vm: GenericViewModel<Item>?
    
    private lazy var mainView: BasicView = {
        let view = BasicView()
        view.backgroundColor = .secondaryGray
        view.cornerRadius = 8
        return view
    }()
    
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.backgroundColor = .clear
        return stack
    }()
    
    private lazy var selectionView: BasicView = {
        let view = BasicView()
        view.backgroundColor = .primaryGreen
        view.cornerRadius = 8
        return view
    }()
    
    private lazy var selectionLabel: BasicLabel = {
        let label = BasicLabel()
        label.numberOfLines = 0
        return label
    }()
    
    private var itemLabels: [TappableLabel] = []
    
    override init() {
        super.init()
        self.cornerRadius = 0
        self.backgroundColor = .clear
        makeLayout()
        makeConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeLayout() {
        self.addSubview(mainView)
        mainView.addSubview(selectionView)
        mainView.addSubview(stack)
        selectionView.addSubview(selectionLabel)
    }
    
    func makeConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(32)
        }
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setSelection() {
        guard let vm else { return }
        let itemWidth = stack.frame.width / CGFloat(vm.items.count)
        let leading = itemWidth * CGFloat(vm.selectedIndex)
        selectionView.snp.remakeConstraints { make in
            make.height.equalTo(stack).inset(UIEdgeInsets(vertical: 2))
            make.width.equalTo(itemWidth)
            make.centerY.equalTo(stack)
            make.leading.equalTo(mainView).offset(leading)
        }
        
        guard !vm.isFisrstLaunch else {
            itemLabels.enumerated().forEach { index, label in
                label.textColor = index == vm.selectedIndex ? .white : .textBlack
            }
            layoutIfNeeded()
            return
        }
        
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let self else { return }
            self.layoutIfNeeded()
        } completion: {[weak self] _ in
            self?.itemLabels.enumerated().forEach { index, label in
                label.textColor = index == vm.selectedIndex ? .white : .textBlack
            }
        }
    }
    
    func setViewModel(_ vm: GenericViewModel<Item>) {
        self.vm = vm

        vm.$items.sink { [weak self] items in
            self?.makeItems()
        }
        .store(in: &cancellables)
        
        vm.$selectedItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedItem in
                self?.setSelection()
                self?.vm?.isFisrstLaunch = false
            }
            .store(in: &cancellables)
    }
    
    private func makeItems() {
        guard let vm else { return }
        stack.clearArrangedSubviews()
        vm.items.enumerated().forEach { [weak self] index, item in
            let label = TappableLabel()
            label.font = .custom(size: 13, weight: .medium)
            self?.itemLabels.append(label)
            let labelVM = TappableLabel.ViewModel(text: vm.titles[index]) { [weak self] in
                self?.vm?.setSelected(item)
            }
            label.setViewModel(labelVM)
            self?.stack.addArrangedSubview(label)
        }
    }
}
