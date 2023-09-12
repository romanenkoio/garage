//
//  SuggestionView.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation
import SwiftUI

class SuggestionView: BasicView {
    
    lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.paddingInsets = UIEdgeInsets(vertical: 7, horizontal: 12)
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var label: TappableLabel = {
        let label = TappableLabel(aligment: .center)
        label.font = .custom(size: 12, weight: .bold)
        label.textColor = AppColors.navbarTitle
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraints()
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        stack.addArrangedSubviews([imageView, label])
        self.backgroundColor = AppColors.background
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.cornerRadius = 12
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(38)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        label.setViewModel(vm.labelVM)
        
        vm.$backgroundColor
            .sink { [weak self] color in
                if let color {
                    self?.backgroundColor = color
                }
            }
            .store(in: &cancellables)
        
        vm.$image.sink { [weak self] image in
            self?.imageView.image = image
            self?.imageView.isHidden = image == nil
            if image != nil {
                self?.stack.paddingInsets = UIEdgeInsets(vertical: 7, horizontal: 12)
            } else {
                self?.stack.paddingInsets = UIEdgeInsets(horizontal: 12)
            }
        }
        .store(in: &cancellables)
        
        vm.$isSelected.sink { [weak self] value in
            self?.layer.borderColor = value ? UIColor(hexString: "#2042E9").cgColor : UIColor.clear.cgColor
        }
        .store(in: &cancellables)
    }
}
