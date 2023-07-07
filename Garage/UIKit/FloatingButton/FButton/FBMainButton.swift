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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
        layer.cornerRadius = 25
        dropShadow(
            color: .black,
            shadowRadius: 5.0,
            shadowOpacity: 0.5
        )
    }
}
