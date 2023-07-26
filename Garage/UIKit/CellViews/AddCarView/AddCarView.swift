//
//  AddCarView.swift
//  Garage
//
//  Created by Illia Romanenko on 21.06.23.
//

import UIKit

class AddCarView: BasicStackView {
    
    let imageButton: BasicImageView = {
       let button = BasicImageView()
        button.tintColor = AppColors.tabbarIcon
        return button
    }()
    
    let textLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = AppColors.tabbarIcon
        label.textAlignment = .center
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        self.backgroundColor = AppColors.background
        self.cornerRadius = 20
        self.alignment = .center
        self.axis = .vertical
        self.spacing = 6
        self.paddingInsets = .init(top: 23, bottom: 21)
    }
    
    private func makeLayout() {
        self.addArrangedSubviews([imageButton, textLabel])
    }
    
    private func makeConstraint() {
        
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        imageButton.setViewModel(vm.imageVM)
        textLabel.setViewModel(vm.textLabelVM)
    }
}
