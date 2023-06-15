//
//  RecordView.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import UIKit

class RecordView: BasicView {
    
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.edgeInsets = UIEdgeInsets(all: 20)
        return stack
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
        self.backgroundColor = .white
        self.cornerRadius = 20
    }
    
    private func makeLayout() {
        addSubview(stack)
        stack.addArrangedSubviews([infoLabel, dateLabel])
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        
    }
}
