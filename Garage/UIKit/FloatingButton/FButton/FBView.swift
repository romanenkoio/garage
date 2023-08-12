//
//  FBView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 7.07.23.
//

import UIKit

class FloatingButtonView: BasicStackView {
    
    private let stackView = FloatingButtonStackView()
    
    private lazy var mainButton: FloatingButtonMainButton = {
        let button = FloatingButtonMainButton()
        button.addTarget(self, action: #selector(mainButtonAction), for: .touchUpInside)
        return button
    }()
    
    private weak var vm: ViewModel?
    
    override init() {
        super.init()
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureContainer()
        makeLayout()
        makeConstraints()
    }
    
    private func configureContainer() {
        distribution = .equalCentering
        axis = .vertical
        alignment = .trailing
        spacing = 16
        layer.masksToBounds = false
        clipsToBounds = true
        dropShadow(color: .gray, shadowOpacity: 1)
        paddingInsets = UIEdgeInsets(all: 5)
    }
    
    private func makeLayout() {
        addArrangedSubview(stackView)
        addArrangedSubview(mainButton)
    }
    
    private func makeConstraints() {
        mainButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(5)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.vm = vm
        
        vm.$isMenuOnScreen.sink {[weak self] value in
            value ?
            self?.stackView.dismissButtons() :
            self?.stackView.showButtons()
            
            if vm.mainButtonAction == nil {
                UIView.animate(withDuration: 0.2) {
                    self?.mainButton.transform = value ?
                    CGAffineTransform.identity :
                    CGAffineTransform(rotationAngle: .pi/4)
                }
            }
            
        }
        .store(in: &cancellables)
        
        vm.$actions.sink { [weak self] actions in
            guard let self else { return }
            actions.forEach({ action in
                let item = FloatingButtonSecondItem()
                item.setViewModel(action)
                self.stackView.addSecondaryButtonWith(component: item)
            })
            self.stackView.setFABButton()
        }
        .store(in: &cancellables)
    }

    @objc private func mainButtonAction() {
        guard let vm else { return }
        if let mainButtonAction = vm.mainButtonAction {
            mainButtonAction()
        }
        
        if let _ = vm.mainButtonAction, !vm.actions.isEmpty {
            fatalError("You set action for \("MainButton") and actions for \("SecondButtons") that's illegal")
        }
        vm.isMenuOnScreen.toggle()
    }
}
