//
//  ServiceView.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//

import Foundation
import UIKit

class ServiceView: BasicView {
    private var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.cornerRadius = 12
        stack.backgroundColor = .textGray
        stack.paddingInsets = .init(all: 10)
        return stack
    }()
    
    private var nameLabel: BasicLabel = {
        let label = BasicLabel()
        return label
    }()
    
    private var phoneLabel: BasicLabel = {
        let label = BasicLabel()
        return label
    }()
    
    private var adressLabel: BasicLabel = {
        let label = BasicLabel()
        return label
    }()
    
    private var specializationLabel: BasicLabel = {
        let label = BasicLabel()
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        stack.addArrangedSubviews([
            nameLabel,
            phoneLabel,
            adressLabel,
            specializationLabel
        ])
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(all: 10))
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        nameLabel.setViewModel(vm.nameLabelVM)
        phoneLabel.setViewModel(vm.phoneLabelVM)
        adressLabel.setViewModel(vm.adressLabelVM)
        specializationLabel.setViewModel(vm.specializationLabelVM)
    }
}
