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
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var attentionView: BasicView = {
        let view = BasicView()
        view.backgroundColor = .clear
        view.cornerRadius = 20
        return view
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
        label.font = .custom(size: 12, weight: .semibold)
        label.textInsets = .init(bottom: 17, left: 16)
        label.textColor = UIColor(hexString: "#939393")
        return label
    }()
    
    private lazy var photoContainer: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private lazy var logoCollection = CarPhotoCollection()
    
    private lazy var detailsView = DetailsView()

    override func initView() {
        makeLayout()
        makeConstraints()
        self.isUserInteractionEnabled = true
    }
    
    private func makeLayout() {
       addSubview(mainStack)
        attentionView.addSubview(attentionImage)
        
        topContainer.addSubview(textStack)
        topContainer.addSubview(attentionView)
        
        mainStack.addArrangedSubviews([topContainer, photoContainer, detailsView])
        textStack.addArrangedSubviews([brandLabel, plannedLabel])
        
        photoContainer.addArrangedSubviews([logoCollection])
    }
    
    private func makeConstraints() {
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        attentionImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.centerY.leading.equalToSuperview()
        }

        attentionView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(16)
            make.trailing.equalToSuperview().inset(UIEdgeInsets(right: 16))
            make.centerY.equalTo(textStack)
        }
        
        textStack.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(attentionView.snp.leading)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        detailsView.setViewModel(vm.detailsVM)
        brandLabel.setViewModel(vm.brandLabelVM)
        plannedLabel.setViewModel(vm.plannedLabelVM)
        logoCollection.setViewModel(vm.carPhotoCollectionVM)
        
        vm.$shouldShowAttention.sink { [weak self] value in
            self?.attentionView.isHidden = !value
        }
        .store(in: &cancellables)
    }
}
