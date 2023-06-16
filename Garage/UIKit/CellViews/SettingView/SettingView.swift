//
//  SettingView.swift
//  Garage
//
//  Created by Illia Romanenko on 17.06.23.
//

import UIKit

class SettingView: BasicView {
    private lazy var settingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.cornerRadius = 4
        imageView.backgroundColor = UIColor(hexString: "DEDEDE")
        return imageView
    }()
    
    private lazy var settingLabel: BasicLabel = {
       let label = BasicLabel()
        label.textInsets = .init(left: 12)
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
            make.trailing.equalToSuperview().offset(16)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        settingLabel.setViewModel(vm.textLabelVM)
    }

}
