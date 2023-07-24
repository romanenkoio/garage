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
        stack.backgroundColor = AppColors.background
        stack.cornerRadius = 20
        return stack
    }()
    
    private lazy var textStack: BasicStackView = {
       let stack = BasicStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var attentionView: BasicView = {
        let view = BasicView()
        view.backgroundColor = .clear
        view.cornerRadius = 20
        return view
    }()
    
    private lazy var attentionImage = BasicImageView()
    lazy var parkingImage = BasicImageView()
    
    private lazy var logoImage: BasicImageView = {
        let imageView = BasicImageView()
        imageView.cornerRadius = 16
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
        label.font = .custom(size: 12, weight: .semibold)
        label.textInsets = .init(bottom: 17, left: 16)
        label.textColor = AppColors.subtitle
        return label
    }()
    
    private lazy var photoContainer: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.paddingInsets = .init(bottom: 16, horizontal: 16)
        return stack
    }()
    
    private lazy var imageStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()

    private lazy var detailsView = DetailsView()

    weak var vm: ViewModel?
    
    override func initView() {
        makeLayout()
        makeConstraints()
        self.isUserInteractionEnabled = true
    }
    
    private func makeLayout() {
        addSubview(mainStack)
        attentionView.addSubview(imageStack)
        imageStack.addArrangedSubviews([attentionImage, parkingImage])
        topContainer.addSubview(textStack)
        topContainer.addSubview(attentionView)
        
        mainStack.addArrangedSubviews([topContainer, photoContainer, detailsView])
        textStack.addArrangedSubviews([brandLabel, plannedLabel])
        
        photoContainer.addArrangedSubviews([logoImage])
    }
    
    private func makeConstraints() {
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        attentionImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
        }
        
        parkingImage.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }

        attentionView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.trailing.equalToSuperview().inset(UIEdgeInsets(right: 16))
            make.centerY.equalTo(textStack)
        }
        
        textStack.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(attentionView.snp.leading)
        }
        
        imageStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        logoImage.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            make.height.equalTo(logoImage.snp.width).multipliedBy(0.62)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()
        self.vm = vm

        parkingImage.setViewModel(vm.parkingImageVM)
        detailsView.setViewModel(vm.detailsVM)
        brandLabel.setViewModel(vm.brandLabelVM)
        plannedLabel.setViewModel(vm.plannedLabelVM)
        logoImage.setViewModel(vm.imageVM)
        attentionImage.setViewModel(vm.attentionImageVM)
    }
}
