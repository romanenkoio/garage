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
    weak var vm: ViewModel?
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(imageView)
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
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        
        self.imageView.setViewModel(vm.logoVM)
    }
}
