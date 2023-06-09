//
//  DocumentView.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import Foundation

class DocumentView: BasicView {
    
    
    private lazy var stack: BasicStackView = {
       let stack = BasicStackView()
        stack.spacing = 5
        stack.axis = .vertical
        stack.cornerRadius = 12
        stack.backgroundColor = .primaryPink.withAlphaComponent(0.5)
        stack.paddingInsets = .init(vertical: 5, horizontal: 10)
        stack.edgeInsets = .init(vertical: 5, horizontal: 16)
        return stack
    }()
    
    private lazy var typeLabel = BasicLabel()
    private lazy var dateLabel = BasicLabel()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        stack.addArrangedSubviews([typeLabel, dateLabel])
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        typeLabel.setViewModel(vm.typeLabelVM)
        dateLabel.setViewModel(vm.dateLabelVM)
    }
}
