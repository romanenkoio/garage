//
//  CarImageSelector.swift
//  Garage
//
//  Created by Illia Romanenko on 18.07.23.
//

import Foundation

class CarImageSelector: BasicView {
    private lazy var imageView: BasicImageView = {
        let view = BasicImageView()
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(imageView)
    }
    
    private func makeConstraint() {
        imageView.snp.makeConstraints { make in
            make.center.top.bottom.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.imageView.setViewModel(vm.logoVM)
    }
}
