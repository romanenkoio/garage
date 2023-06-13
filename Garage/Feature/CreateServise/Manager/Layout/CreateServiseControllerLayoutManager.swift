//
//  CreateServiseControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//  
//

import UIKit
import SnapKit

final class CreateServiseControllerLayoutManager {
    
    private unowned let vc: CreateServiseViewController
    
    lazy var nameInput = BasicInputView()
    lazy var phoneInput = BasicInputView()
    lazy var specialisationInput = BasicInputView()
    lazy var adressInput = BasicInputView()
    lazy var saveButton = BasicButton()
    
    lazy var fieldStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    // - Init
    init(vc: CreateServiseViewController) {
        self.vc = vc
        configure()
        
        let trashButtonVM = NavBarButton.ViewModel(
            action: .touchUpInside {
//                vc.coordinator.navigateTo(GarageNavigationRoute.createCar)
            },
            image: UIImage(systemName: "trash")
        )
        vc.makeRightNavBarButton(buttons: [trashButtonVM])
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CreateServiseControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(fieldStack)
        fieldStack.addArrangedSubviews([
            nameInput,
            phoneInput,
            specialisationInput,
            adressInput,
            saveButton
        ])
    }
    
    private func makeConstraint() {
        fieldStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
