//
//  AddCarView.swift
//  Garage
//
//  Created by Illia Romanenko on 21.06.23.
//

import UIKit

class AddCarView: BasicStackView {
    
    let imageButton: UIImageView = {
       let button = UIImageView()
        button.image = UIImage(named: "plus_car_ic")
        button.tintColor = UIColor(hexString: "#ADADAD")
        return button
    }()
    
    let textLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = UIColor(hexString: "#ADADAD")
        label.textAlignment = .center
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        self.backgroundColor = UIColor(hexString: "#F5F5F5")
        self.cornerRadius = 20
        self.alignment = .center
        self.axis = .vertical
        self.spacing = 6
        self.paddingInsets = .init(top: 23, bottom: 21)
        self.edgeInsets = .init(top: 20, horizontal: 20)
    }
    
    private func makeLayout() {
        self.addArrangedSubviews([imageButton, textLabel])
    }
    
    private func makeConstraint() {
        
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        textLabel.setViewModel(vm.textLabelVM)
    }
}
