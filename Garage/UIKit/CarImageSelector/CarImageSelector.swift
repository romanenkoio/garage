//
//  CarImageSelector.swift
//  Garage
//
//  Created by Illia Romanenko on 18.07.23.
//

import UIKit

class CarImageSelector: BasicView {
    private lazy var imageView: BasicImageView = {
        let view = BasicImageView(mode: .scaleAspectFill)
        view.cornerRadius = 50
        view.isUserInteractionEnabled = true
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.blue.cgColor
        return view
    }()
    
    private lazy var plusImageView: BasicImageView = {
        let view = BasicImageView(
            image: UIImage(named: "photo_plus_ic"),
            mode: .scaleAspectFill
        )
        return view
    }()

    weak var vm: ViewModel?
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(imageView)
        self.addSubview(plusImageView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        imageView.addGestureRecognizer(tap)
    }
    
    @objc private func imageTap() {
        vm?.action?()
    }
    
    private func makeConstraint() {
        imageView.snp.makeConstraints { make in
            make.center.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, bottom: 10))
            make.height.width.equalTo(100)
        }
        
        plusImageView.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.centerX.equalTo(imageView.snp.trailing).offset(-10)
            make.centerY.equalTo(imageView.snp.bottom).offset(-10)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        
        self.imageView.setViewModel(vm.logoVM)
    }
}
