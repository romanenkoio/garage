//
//  RecordView.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import UIKit

class RecordView: BasicView {
    
//    private lazy var stack: BasicStackView = {
//        let stack = BasicStackView()
//        stack.axis = .vertical
//        stack.spacing = 4
//        stack.distribution = .fillEqually
//        stack.edgeInsets = UIEdgeInsets(all: 20)
//        return stack
//    }()
    
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
        self.backgroundColor = .white
        self.cornerRadius = 20
    }
    
    private func makeLayout() {
        addSubview(infoLabel)
        addSubview(dateLabel)
//        stack.addArrangedSubviews([infoLabel, dateLabel])
        
    }
    
    private func makeConstraint() {
        infoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        infoLabel.setViewModel(vm.infoLabelVM)
        dateLabel.setViewModel(vm.dateLabelVM)
    }
}
