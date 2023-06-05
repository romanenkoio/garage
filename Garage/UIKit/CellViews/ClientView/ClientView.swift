//
//  ClientView.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import Foundation

class ClienView: BasicView {
    static let id = String(describing: ClienView.self)
    
    private lazy var stack: BasicStackView = {
        let view = BasicStackView()
        view.paddingInsets = .init(vertical: 8, horizontal: 16)
        view.spacing = 5
        return view
    }()
    
    private lazy var nameLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 17, weight: .medium)
        return label
    }()
    
    private lazy var phoneLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 15, weight: .medium)
        label.textColor = .textGray
        return label
    }()
    
    override func initView() {
        super.initView()
        makeLayout()
        makeConstraints()
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        stack.addArrangedSubviews([nameLabel, phoneLabel])
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        nameLabel.setViewModel(vm.nameVM)
        phoneLabel.setViewModel(vm.phoneVM)
    }
}
