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
        stack.backgroundColor = UIColor(hexString: "EFEFEF")
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
        label.textInsets = .init(bottom: 25, horizontal: 24)
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = UIColor(hexString: "939393")
        return label
    }()
    
    private lazy var detailsView: BasicView = {
        let stack = BasicView()
        stack.backgroundColor = UIColor(hexString: "0C0C0C").withAlphaComponent(0.08)
        stack.cornerRadius = 0
        return stack
    }()
    
    private lazy var detailsLabel: BasicLabel = {
        let label = BasicLabel()
        label.textInsets = .init(top: 24, bottom: 24, left: 24)
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = ColorScheme.standartBlue.buttonColor
        return label
    }()
    
    private lazy var detailsImage: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "arrow_right_ic")?.withTintColor(ColorScheme.standartBlue.buttonColor)
        return view
    }()

    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        stack.addArrangedSubviews([
            nameLabel,
            adressLabel,
            detailsView
        ])
        
        detailsView.addSubview(detailsLabel)
        detailsView.addSubview(detailsImage)
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        detailsImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.centerY.trailing.equalToSuperview().inset(UIEdgeInsets(right: 24))
            make.leading.greaterThanOrEqualTo(detailsLabel.snp.trailing)
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        nameLabel.setViewModel(vm.nameLabelVM)
        adressLabel.setViewModel(vm.adressLabelVM)
        detailsLabel.setViewModel(vm.detailsLabelVM)
    }
}
