//
//  FBMainButton.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 7.07.23.
//

import UIKit

class FloatingButtonMainButton: UIButton {

    init() {
        super.init(frame: .zero)
        configure()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {

        clipsToBounds = true
        cornerRadius = 36
        backgroundColor = AppColors.blue
        setImage(UIImage(named: "plus_car_ic"), for: .normal)
        tintColor = .white
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(72)
        }
    }
}
