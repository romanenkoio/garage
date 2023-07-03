//
//  CallButton.swift
//  Garage
//
//  Created by Illia Romanenko on 24.06.23.
//

import UIKit

class CallButton: BasicStackView {
    var vm: ViewModel?
    
    private lazy var callLabel: BasicLabel = {
        let label = BasicLabel()
        label.text = "Позвонить"
        label.font = .custom(size: 12, weight: .semibold)
        return label
    }()
    
    private lazy var callImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "phone_ic")
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        self.backgroundColor = .white
        self.cornerRadius = 20
        self.spacing = 4
        self.axis = .horizontal
        self.edgeInsets = .init(right: 16)
        self.paddingInsets = .init(vertical: 13, horizontal: 20)
        let tap = UITapGestureRecognizer(target: self, action: #selector(call))
        self.addGestureRecognizer(tap)
    }
    
    private func makeLayout() {
        self.addArrangedSubviews([callImage, callLabel])
    }
    
    private func makeConstraint() {
        snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(136)
        }
        
        callImage.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
    }
    
    @objc private func call() {
        vm?.call()
    }
}
