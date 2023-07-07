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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorScheme.current.buttonColor
        button.setImage(UIImage(named: "plus_car_ic"), for: .normal)
        button.tintColor = .white
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
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .equalCentering
        axis = .vertical
        alignment = .trailing
        spacing = 16
        clipsToBounds = true
        paddingInsets = UIEdgeInsets(all: 10)
    }
    
    private func makeLayout() {
        addArrangedSubview(stackView)
        addArrangedSubview(mainButton)
    }
    
    private func makeConstraints() {
        mainButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(bottom: 10, right: 10))
            make.width.height.equalTo(50)
        }
        
        stackView.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.width.equalTo(150)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        
        vm.$isMenuOnScreen.sink { value in
            value ? self.stackView.dismissButtons() : self.stackView.showButtons()
            print(value)
        }
        .store(in: &cancellables)
        
        vm.$actions.sink { [weak self] actions in
            guard let self else { return }
            actions.forEach({ action in
                let label = TappableLabel(aligment: .center)
                label.font = .custom(size: 14, weight: .semibold)
                label.cornerRadius = 12
                label.textColor = .white
                label.backgroundColor = ColorScheme.current.buttonColor
                label.setViewModel(action)

                self.stackView.addSecondaryButtonWith(component: label)
            })
            self.stackView.setFABButton()
        }
        .store(in: &cancellables)
    }

    @objc private func mainButtonAction(isOpen: Bool) {
        guard let vm else { return }
        vm.isMenuOnScreen.toggle()
    }
}
