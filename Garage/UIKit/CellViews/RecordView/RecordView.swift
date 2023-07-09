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
    
    private lazy var attentionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "more_ic")
        return imageView
    }()
    
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
    
    override func initView() {
        makeLayout()
        makeConstraint()
        self.backgroundColor = .clear
    }
    
    private func makeLayout() {
        addSubview(containerView)
        containerView.addSubview(stack)
        containerView.addSubview(attentionView)
        attentionView.addSubview(attentionImage)
        stack.addArrangedSubviews([infoLabel, dateLabel])
    }
    
    private func makeConstraint() {
        attentionImage.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.centerY.leading.equalToSuperview().inset(UIEdgeInsets(right: 30))
        }
        
        attentionView.snp.makeConstraints { make in
            make.height.equalTo(containerView)
            make.width.equalTo(28)
            make.trailing.equalToSuperview().inset(UIEdgeInsets(right: 30))
            make.centerY.equalTo(stack)
        }
    
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 20))
            make.top.bottom.equalToSuperview().inset(UIEdgeInsets(vertical: 6))
        }
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        infoLabel.setViewModel(vm.infoLabelVM)
        dateLabel.setViewModel(vm.dateLabelVM)
    }
}
