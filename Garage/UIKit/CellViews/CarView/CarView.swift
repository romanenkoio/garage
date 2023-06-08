//
//  CarView.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit

class CarView: BasicView {
    private lazy var mainStack: BasicStackView = {
        let stack = BasicStackView()
        stack.spacing = 10
        stack.axis = .horizontal
        stack.edgeInsets = .init(horizontal: 16)
        stack.paddingInsets = .init(vertical: 5, horizontal: 10)
        stack.cornerRadius = 20
        stack.backgroundColor = .primaryGray
        stack.alignment = .center
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var textStack: BasicStackView = {
        let stack = BasicStackView()
        stack.spacing = 5
        stack.axis = .vertical
        stack.paddingInsets = .init(vertical: 5)
        return stack
    }()

    private lazy var brandLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 25, weight: .medium)
        label.textColor = .textBlack
        return label
    }()
    
    private lazy var modelLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 15, weight: .light)
        label.textColor = .textGray
        return label
    }()
    
    private lazy var notificationView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "flag.circle.fill")
        view.tintColor = .additionalRed
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraints()
        self.isUserInteractionEnabled = true
    }
    
    private func makeLayout() {
        self.addSubview(mainStack)
        mainStack.addArrangedSubviews([imageView, textStack, notificationView])
        textStack.addArrangedSubviews([brandLabel, modelLabel])
    }
    
    private func makeConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
        
        notificationView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.cancellables.removeAll()
        brandLabel.setViewModel(vm.brandLabelVM)
        modelLabel.setViewModel(vm.modelLabelVM)
    }
}
