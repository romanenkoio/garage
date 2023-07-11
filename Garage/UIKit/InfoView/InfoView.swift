//
//  BasicInfoView.swift
//  Logogo
//
//  Created by Illia Romanenko on 19.05.23.
//

import UIKit

class InfoView: BasicStackView {
    
    private(set) weak var vm: ViewModel?
    
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.cornerRadius = 16
        stack.paddingInsets = .init(vertical: 12)
        stack.backgroundColor = .primaryGray
        return stack
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .custom(size: 21, weight: .semibold)
        label.textColor = .textBlack
        return label
    }()
    
    private lazy var emptyLabel: UILabel = {
       let label = UILabel()
        label.font = .custom(size: 15, weight: .medium)
        label.textColor = .textGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var rightActiomlabel: UILabel = {
        let label = UILabel()
        label.font = .custom(size: 15, weight: .semibold)
        label.textColor = .primaryBlue
        return label
    }()
    
    override func initView() {
        super.initView()
        makeLayout()
        self.spacing = 16
        self.paddingInsets = UIEdgeInsets(horizontal: 16)
    }
    
    func makeLayout() {
        self.addArrangedSubviews([
            label,
            stack
        ])
    }
    
    private func makeEmptyView() {
        self.stack.addArrangedSubview(emptyLabel)
        emptyLabel.text = vm?.emptyText
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.vm = vm
        vm.$title.sink { [weak self] value in
            self?.label.text = value
        }
        .store(in: &cancellables)
        
        vm.$subviews.sink { [weak self] views in
            self?.stack.clearArrangedSubviews()
            if views.isEmpty {
                self?.makeEmptyView()
            } else {
                views.forEach { self?.stack.addArrangedSubview($0) }
            }
            self?.layoutIfNeeded()
        }
        .store(in: &cancellables)
    }
}
