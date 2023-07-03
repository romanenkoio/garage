//
//  FloatingButton.swift
//  Garage
//
//  Created by Illia Romanenko on 22.06.23.
//

import UIKit

class FloatingButton: BasicView {
    private weak var vm: ViewModel?
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "plus_car_ic")?.withTintColor(.white)
        return view
    }()
    
    var actionStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        backgroundColor = ColorScheme.current.buttonColor
        let openTap = UITapGestureRecognizer(target: self, action: #selector(openTap))
        self.addGestureRecognizer(openTap)
        
        self.cornerRadius = 24
    }
    
    private func makeLayout() {
        self.addSubview(imageView)
        self.addSubview(actionStack)
    }
    
    private func makeConstraint() {
        self.snp.makeConstraints { make in
            make.height.width.equalTo(72)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.center.equalToSuperview()
        }
        
        actionStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        
        vm.$isOpen.dropFirst().sink { [weak self] value in
            guard let self, let vm = self.vm else { return }
            if vm.actions.count == 1,
               let lable = vm.actions.first {
                lable.action?()
            } else {
                self.remakeState(isOpen: value)
            }
        }
        .store(in: &cancellables)
    }
    
    func makeActions() {
        actionStack.clearArrangedSubviews()
        
        vm?.actions.forEach({ [weak self] action in
            guard let self else { return }
            let label = TappableLabel(aligment: .center)
            label.font = .custom(size: 14, weight: .semibold)
            label.textColor = .white
            label.setViewModel(action)
            self.actionStack.addArrangedSubview(label)
        })
    }
    
    func remakeState(isOpen: Bool) {
        makeActions()
        guard let vm = self.vm else { return }

        if isOpen {
            self.snp.updateConstraints { make in
                make.height.equalTo(30 * vm.actions.count)
                make.width.equalTo(150)
                guard let superview else { return }
            }
        } else {
            self.snp.updateConstraints { make in
                make.height.width.equalTo(72)
            }
        }
        
        actionStack.isHidden = !isOpen
        imageView.isHidden = isOpen
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    @objc private func openTap() {
        self.vm?.isOpen = true
    }
}
