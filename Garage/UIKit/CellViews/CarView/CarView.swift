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
        stack.edgeInsets = .init(vertical: 8, horizontal: 16)
        stack.paddingInsets = .init(vertical: 20, horizontal: 17)
        stack.cornerRadius = 20
        stack.backgroundColor = UIColor(hexString: "EDEDED")
        stack.backgroundColor = .primaryGray
        stack.alignment = .center
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.cornerRadius = 10
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var textStack: BasicStackView = {
        let stack = BasicStackView()
        stack.spacing = 4
        stack.axis = .vertical
        stack.paddingInsets = .init(vertical: 5)
        stack.edgeInsets = .init(left: 13)
        return stack
    }()

    private lazy var brandLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 18, weight: .black)
        label.textColor = .textBlack
        return label
    }()
    
    private lazy var modelLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 18, weight: .bold)
        label.textColor = .textGray
        return label
    }()
    
    private lazy var notificationView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrow_ic")
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
            make.height.equalTo(80)
        }
        
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
        
        notificationView.snp.makeConstraints { make in
            make.height.width.equalTo(25)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.cancellables.removeAll()
        brandLabel.setViewModel(vm.brandLabelVM)
        modelLabel.setViewModel(vm.modelLabelVM)
        self.imageView.image = vm.image
    }
}
