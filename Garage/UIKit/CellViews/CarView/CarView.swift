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
        stack.axis = .vertical
        stack.backgroundColor = UIColor(hexString: "#F5F5F5")
        stack.cornerRadius = 20
        stack.edgeInsets = .init(top: 20, horizontal: 20)
        return stack
    }()
    
    private lazy var textStack: BasicStackView = {
       let stack = BasicStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var attentionView: BasicView = {
        let view = BasicView()
        view.backgroundColor = .white
        view.cornerRadius = 20
        return view
    }()
    
    private lazy var attentionLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 11, weight: .bold)
        label.textColor = UIColor(hexString: "#E84949")
        label.textInsets = .init(left: 6, right: 5)
        label.text = "Течдлаоы длывао ывлао "
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var attentionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "error_ic")
        return imageView
    }()
    
    private lazy var topContainer: BasicView = {
        let view = BasicView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var brandLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .black)
        label.textInsets = .init(top: 24, bottom: 4, left: 16)
        return label
    }()
    
    private lazy var plannedLabel: BasicLabel = {
        let label = BasicLabel()
        label.text = "Запланированно"
        label.font = .custom(size: 12, weight: .semibold)
        label.textInsets = .init(bottom: 24, left: 16)
        return label
    }()
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.cornerRadius = 16
        imageView.image = UIImage(named: "car")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var detailsView = DetailsView()

    override func initView() {
        makeLayout()
        makeConstraints()
        self.isUserInteractionEnabled = true
    }
    
    private func makeLayout() {
       addSubview(mainStack)
        attentionView.addSubview(attentionLabel)
        attentionView.addSubview(attentionImage)
        
        topContainer.addSubview(textStack)
        topContainer.addSubview(attentionView)
        
        mainStack.addArrangedSubviews([topContainer, logoImage, detailsView])
        textStack.addArrangedSubviews([brandLabel, plannedLabel])
    }
    
    private func makeConstraints() {
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        attentionImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.centerY.leading.equalToSuperview().inset(UIEdgeInsets(left: 12))
        }
        
        attentionLabel.snp.makeConstraints { make in
            make.leading.equalTo(attentionImage.snp.trailing)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        attentionView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(116)
            make.trailing.equalToSuperview().inset(UIEdgeInsets(right: 16))
            make.centerY.equalTo(textStack)
        }
        
        logoImage.snp.makeConstraints { make in
            make.height.equalTo(188)
        }
        
        textStack.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(attentionView.snp.leading)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        detailsView.setViewModel(vm.detailsVM)
        brandLabel.setViewModel(vm.brandLabelVM)
    }
}
