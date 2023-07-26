//
//  CarPinView.swift
//  Garage
//
//  Created by Illia Romanenko on 25.07.23.
//

import Foundation

final class CarPinView: BasicView {
    private lazy var pinImage = BasicImageView()
    private lazy var carImage = BasicImageView()
    
    private var vm: ViewModel!
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(pinImage)
        self.addSubview(carImage)
        
        carImage.cornerRadius = 13
    }
    
    private func makeConstraint() {
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(self.snp.height).multipliedBy(0.75)
        }
        
        self.pinImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.carImage.snp.makeConstraints { make in
            make.centerX.equalTo(pinImage)
            make.width.height.equalTo(26)
            make.top.equalTo(pinImage).offset(8)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        self.pinImage.setViewModel(vm.pinImageVM)
        self.carImage.setViewModel(vm.сarImageVM)
    }
}
