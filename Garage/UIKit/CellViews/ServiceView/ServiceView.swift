//
//  ServiceView.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//

import Foundation
import UIKit

class ServiceView: BasicView {
    private lazy var stack: BasicStackView = {
       let stack = BasicStackView()
        stack.spacing = 5
        stack.axis = .vertical
        stack.cornerRadius = 12
        stack.backgroundColor = AppColors.background
        stack.edgeInsets = .init(vertical: 12, horizontal: 21)
        return stack
    }()
    
    private lazy var nameLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 18, weight: .black)
        label.textColor = .black
        label.textInsets = .init(top: 24, horizontal: 24)
        return label
    }()
    
    private lazy var adressLabel: BasicLabel = {
        let label = BasicLabel()
        label.textInsets = .init(bottom: 16, horizontal: 24)
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = UIColor(hexString: "939393")
        return label
    }()
    
    private lazy var topStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    private lazy var textStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var detailsView = DetailsView()
    private lazy var callButton = CallButton()

    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        stack.addArrangedSubviews([
            topStack,
            detailsView
        ])
        
        textStack.addArrangedSubviews([nameLabel,
                                      adressLabel])
        
        topStack.addArrangedSubviews([textStack, callButton])
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        nameLabel.setViewModel(vm.nameLabelVM)
        adressLabel.setViewModel(vm.adressLabelVM)
        detailsView.setViewModel(vm.detailVM)
        callButton.setViewModel(vm.callButtonVM)
    }
}
