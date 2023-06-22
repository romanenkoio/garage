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
        view.backgroundColor = .clear
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

    private var itemViews: [SegmentButton] = []
    
    override init() {
        super.init()
        self.cornerRadius = 0
        self.backgroundColor = AppColors.background
        makeLayout()
        makeConstraints()
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
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
        mainView.addSubview(stack)
    }
    
    func makeConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setSelection() {
        guard let vm else { return }
        
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let self else { return }
            self.layoutIfNeeded()
        } completion: {[weak self] _ in
            self?.itemViews.enumerated().forEach { index, view in
                view.label.textColor = index == vm.selectedIndex ? ColorScheme.current.textColor : .lightGray
                view.lineView.backgroundColor = index == vm.selectedIndex ? ColorScheme.current.textColor : .lightGray
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
            }
            .store(in: &cancellables)
    }
    
    private func makeItems() {
        guard let vm else { return }
        stack.clearArrangedSubviews()
        vm.items.enumerated().forEach { [weak self] index, item in
            let view = SegmentButton()
            self?.itemViews.append(view)
            let labelVM = TappableLabel.ViewModel(text: vm.titles[index]) { [weak self] in
                self?.vm?.setSelected(item)
            }
            view.setViewModel(.init(labelVM: labelVM))
            self?.stack.addArrangedSubview(view)
        }
    }
}

class SegmentButton: BasicStackView {
    let label = TappableLabel()
    let lineView = BasicView()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        self.axis = .vertical
        self.distribution = .fill
        label.textInsets = .init(top: 21, bottom: 11)
        label.font = .custom(size: 18, weight: .bold)
        label.textAlignment = .center
        lineView.cornerRadius = 0
    }
    
    private func makeLayout() {
        self.addArrangedSubviews([label, lineView])
    }
    
    private func makeConstraint() {
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        label.setViewModel(vm.labelVM)
    }
}

extension SegmentButton {
    final class ViewModel: BasicViewModel {
        let labelVM: TappableLabel.ViewModel
        
        init(labelVM: TappableLabel.ViewModel) {
            self.labelVM = labelVM
        }
    }
}
