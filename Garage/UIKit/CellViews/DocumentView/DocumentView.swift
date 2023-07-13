//
//  DocumentView.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import Foundation
import UIKit

class DocumentView: BasicView {
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
    
    private lazy var typeLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .black)
        label.textInsets = .init(top: 24, bottom: 4, left: 16)
        return label
    }()
    
    private lazy var dateLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 12, weight: .semibold)
        label.textInsets = .init(bottom: 17, left: 16)
        label.textColor = AppColors.subtitle
        return label
    }()
    
    private lazy var photoContainer: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private lazy var documentPhotoCollection = CarPhotoCollection()
    
    private lazy var detailsView = DetailsView()

    private(set) var vm: ViewModel?

    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        addSubview(mainStack)
         attentionView.addSubview(attentionImage)
         
         topContainer.addSubview(textStack)
         topContainer.addSubview(attentionView)
         
         mainStack.addArrangedSubviews([topContainer, photoContainer, detailsView])
         textStack.addArrangedSubviews([typeLabel, dateLabel])
         
         photoContainer.addArrangedSubviews([documentPhotoCollection])
    }
    
    private func makeConstraint() {
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
    
//    private func setupEmptyState(_ vm: ViewModel) {
//        if vm.documentPhotoCollectionVM.collectionVM.isEmpty {
//            photoContainer.removeFromSuperview()
//        }
//    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()
        detailsView.setViewModel(vm.detailVM)
        typeLabel.setViewModel(vm.typeLabelVM)
        dateLabel.setViewModel(vm.dateLabelVM)
        documentPhotoCollection.setViewModel(vm.documentPhotoCollectionVM)
        
        vm.$shouldShowAttention.sink { [weak self] value in
            self?.attentionView.isHidden = !value
        }
        .store(in: &cancellables)
        
//        setupEmptyState(vm)
    }
}
