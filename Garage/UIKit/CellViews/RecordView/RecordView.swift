//
//  RecordView.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import UIKit

class RecordView: BasicView {
    
    private lazy var containerView: BasicStackView = {
        let view = BasicStackView()
        view.axis = .horizontal
        view.backgroundColor = .white
        view.cornerRadius = 16
        return view
    }()
    
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.edgeInsets = UIEdgeInsets(all: 20)
        stack.backgroundColor = .white
        return stack
    }()
    
    private lazy var attentionView: BasicView = {
        let view = BasicView()
        return view
    }()
    
    private lazy var moreImage = BasicImageView()
    private lazy var attachImage = BasicImageView()
    
    private lazy var infoLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var dateLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    private(set) var vm: ViewModel?
    
    override func initView() {
        makeLayout()
        makeConstraint()
        self.backgroundColor = .clear
    }
    
    private func makeLayout() {
        addSubview(containerView)
        containerView.addSubview(stack)
        containerView.addSubview(attachImage)
        containerView.addSubview(moreImage)
        stack.addArrangedSubviews([infoLabel, dateLabel])
    
    }
    
    private func makeConstraint() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 20))
            make.top.bottom.equalToSuperview().inset(UIEdgeInsets(vertical: 6))
        }
        
        stack.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(attachImage.snp.leading).offset(10)
        }
        
        attachImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
            make.trailing.equalTo(moreImage.snp.leading).offset(-9)
        }
        
        moreImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(28)
            make.trailing.equalToSuperview().offset(-30)
        }
        
//        stack.snp.makeConstraints { make in
//            make.leading.top.bottom.equalToSuperview()
//            make.trailing.equalTo(attachImage.snp.leading).offset(10)
//        }
//        moreImage.snp.makeConstraints { make in
//            make.width.height.equalTo(28)
//            make.trailing.equalToSuperview().inset(UIEdgeInsets(right: 30))
//            make.centerY.equalTo(stack)
//        }
//
    
        
     
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        cancellables.removeAll()
        infoLabel.setViewModel(vm.infoLabelVM)
        dateLabel.setViewModel(vm.dateLabelVM)
        moreImage.setViewModel(vm.moreImageVM)
        attachImage.setViewModel(vm.attachImageVM)
    }
}
