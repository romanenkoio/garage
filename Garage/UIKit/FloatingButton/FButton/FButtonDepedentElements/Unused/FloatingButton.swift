//
//  FloatingButton.swift
//  Garage
//
//  Created by Illia Romanenko on 22.06.23.
//

import UIKit

class FloatingButton: BasicView {
    private weak var vm: ViewModel?
    
    var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        return stack
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "plus_car_ic")?.withTintColor(.white)
        view.backgroundColor = AppColors.blue
        return view
    }()
    
    var imageViewContainer: BasicView = {
        let view = BasicView()
        view.backgroundColor = .clear
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
        backgroundColor = .clear
        let openTap = UITapGestureRecognizer(target: self, action: #selector(openTap))
        self.addGestureRecognizer(openTap)
        
        self.cornerRadius = 24
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        self.addSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
        stack.addArrangedSubviews([actionStack])
    }
    
    private func makeConstraint() {
        imageViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(75)
        }

        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.top)
            make.top.leading.trailing.equalToSuperview()
        }

        actionStack.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

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
            label.backgroundColor = AppColors.blue
            label.setViewModel(action)
            self.actionStack.addArrangedSubview(label)
        })
    }
    
    func remakeState(isOpen: Bool) {
        makeActions()
        guard let vm = self.vm else { return }

//        if isOpen {
//            self.snp.updateConstraints { make in
//                make.height.equalTo(72 * vm.actions.count)
//                make.width.equalTo(72)
//            }
//        } else {
//            self.snp.updateConstraints { make in
//                make.height.width.equalTo(72)
//            }
//        }
        
//        actionStack.isHidden = !isOpen
//        imageView.isHidden = isOpen
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.layoutIfNeeded()
            self?.actionStack.isHidden = !isOpen
        }
    }
    
    @objc private func openTap() {
        self.vm?.isOpen = true
    }
}
