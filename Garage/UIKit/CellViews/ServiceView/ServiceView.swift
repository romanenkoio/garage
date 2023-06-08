//
//  ServiceView.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//

import Foundation

class ServiceView: BasicView {
    private var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private var nameLabel: BasicLabel = {
        let label = BasicLabel()
        return label
    }()
    
    private var phoneLabel: BasicLabel = {
        let label = BasicLabel()
        return label
    }()
}
