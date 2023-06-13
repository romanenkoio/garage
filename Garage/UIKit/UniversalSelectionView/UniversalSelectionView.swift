//
//  UniversalSelectionView.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

final class UniversalSelectionView: BasicView {
    
    private lazy var titleLabel: BasicLabel = {
        let label = BasicLabel()
        label.textInsets = .init(vertical: 15, horizontal: 20)
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(titleLabel)
    }
    
    private func makeConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        titleLabel.setViewModel(vm.labelVM)
    }
}
