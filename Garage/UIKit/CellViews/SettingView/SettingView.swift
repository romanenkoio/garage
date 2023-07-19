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
        label.textInsets = .init(left: 12)
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
    
    private lazy var arrorwImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrow_right_ic")
        view.isHidden = true
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        self.backgroundColor = UIColor(hexString: "F5F5F5")
    }
    
    private func makeLayout() {
        self.addSubview(settingImage)
        self.addSubview(settingLabel)
        self.addSubview(buttonsStack)
        buttonsStack.addArrangedSubviews([settingSwitch, arrorwImage])
    }
    
    private func makeConstraint() {
        settingImage.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.top.bottom.equalToSuperview().inset(UIEdgeInsets(all: 20))
        }
        
        settingLabel.snp.makeConstraints { make in
            make.leading.equalTo(settingImage.snp.trailing)
            make.centerY.equalTo(settingImage)
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
        
        vm.switchVM.$isOn.dropFirst().sink { [weak self] value in
            vm.switchCompletion?(value)
        }
        .store(in: &cancellables)
    }

}
