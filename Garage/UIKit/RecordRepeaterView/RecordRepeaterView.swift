//
//  RecordRepeaterView.swift
//  Garage
//
//  Created by Illia Romanenko on 15.08.23.
//

import Foundation
import UIKit

class RecordRepeaterView: BasicStackView {
    
    private lazy var container: BasicView = {
        let view = BasicView()
        view.backgroundColor = .clear
        view.cornerRadius = 0
        return view
    }()
    
    private lazy var basicLabel: BasicLabel = {
        let label = BasicLabel()
        return label
    }()
    
    private lazy var checkImage: BasicImageView = {
        let image = BasicImageView()
        return image
    }()
    
    lazy var repeatingStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.isHidden = true
        return stack
    }()

    unowned var vm: ViewModel!
    
    override func initView() {
        makeLayout()
        makeConstraint()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
        self.axis = .vertical
        self.spacing = 10
    }
    
    private func makeLayout() {
        self.addArrangedSubview(container)
        container.addSubview(basicLabel)
        container.addSubview(checkImage)
        self.addArrangedSubview(repeatingStack)
    }
    
    private func makeConstraint() {
        basicLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        checkImage.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.height.width.equalTo(30)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        basicLabel.setViewModel(vm.labelVM)
        checkImage.setViewModel(vm.selectImageVM)
        setupRepeatingStack()
        
        vm.$isSelect.dropFirst().sink { [weak self] value in
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.repeatingStack.isHidden = !value
            }
        }
        .store(in: &cancellables)
       
    }
    
    func setupRepeatingStack() {
        repeatingStack.clearArrangedSubviews()
        let views = vm.interval.map({
            let view = SuggestionView()
            view.setViewModel(.init(labelVM: .init(.text($0.title))))
            return view
        })
        repeatingStack.addArrangedSubviews(views)
    }
    
    @objc private func tapAction() {
        vm.isSelect = !vm.isSelect
    }
}
