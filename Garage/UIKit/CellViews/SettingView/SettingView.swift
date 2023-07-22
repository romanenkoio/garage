//
//  SettingView.swift
//  Garage
//
//  Created by Illia Romanenko on 17.06.23.
//

import UIKit

class SettingView: BasicView {
    private lazy var settingImage: BasicImageView = {
        let imageView = BasicImageView(mode: .scaleAspectFill)
        imageView.cornerRadius = 4
        return imageView
    }()
    
    private lazy var settingLabel: BasicLabel = {
       let label = BasicLabel()
        label.font = .custom(size: 14, weight: .semibold)
        return label
    }()
    
    private lazy var buttonsStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var settingSwitch: BasicSwitch = {
        let `switch` = BasicSwitch()
        return `switch`
    }()
    
    private lazy var arrorwImage: BasicImageView = {
        let view = BasicImageView()
        return view
    }()
    
    private lazy var imageStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        return stack
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        self.backgroundColor = AppColors.background
    }
    
    private func makeLayout() {
        self.addSubview(imageStack)
        imageStack.addArrangedSubviews([settingImage, settingLabel])
        self.addSubview(buttonsStack)
        buttonsStack.addArrangedSubviews([settingSwitch, arrorwImage])
    }
    
    private func makeConstraint() {
        imageStack.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview().inset(UIEdgeInsets(vertical: 20))
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.centerY.equalTo(settingImage)
            make.leading.greaterThanOrEqualTo(settingLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        settingImage.setViewModel(vm.imageVM)
        settingSwitch.setViewModel(vm.switchVM)
        settingLabel.setViewModel(vm.textLabelVM)
        arrorwImage.setViewModel(vm.arrovImageVM)
        
        vm.switchVM.$isOn.dropFirst().sink { value in
            vm.switchCompletion?(value)
        }
        .store(in: &cancellables)
        
        vm.$isEnabled.compactMap().sink { [weak self] value in
            self?.isUserInteractionEnabled = value
            self?.settingImage.alpha = value ? 1 : 0.5
            self?.settingLabel.alpha = value ? 1 : 0.5
        }
        .store(in: &cancellables)
    }
}
