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
        stack.spacing = 8
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
        label.textColor = UIColor(hexString: "#3D3D3D")
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraints()
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        stack.addArrangedSubviews([imageView, label])
        self.backgroundColor = UIColor(hexString: "#F5F5F5")
        self.cornerRadius = 12
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        label.setViewModel(vm.labelVM)
        
        vm.$image.sink { [weak self] image in
            self?.imageView.image = image
            self?.imageView.isHidden = image == nil
        }
        .store(in: &cancellables)
    }
}
