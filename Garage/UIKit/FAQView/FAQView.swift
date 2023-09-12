//
//  FAQView.swift
//  Garage
//
//  Created by Illia Romanenko on 12.09.23.
//

import Foundation

class FAQView: BasicView {
    
    private lazy var periodLabel: BasicLabel = {
        let label = BasicLabel(font: .custom(size: 16, weight: .regular))
        label.textAlignment = .center
        label.textColor = AppColors.black
        label.textInsets = .init(top: 15, bottom: 15, right: 16)
        return label
    }()
    
    private lazy var titleLabel: BasicLabel = {
        let label = BasicLabel(font: .custom(size: 16, weight: .regular))
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = AppColors.black
        label.textInsets = .init(top: 15, bottom: 15, left: 16)
        return label
    }()

    override func initView() {
        makeLayout()
        makeConstraint()
        isUserInteractionEnabled = false
        self.backgroundColor = AppColors.background
    }
    
    private func makeLayout() {
        self.addSubview(titleLabel)
        self.addSubview(periodLabel)
    }
    
    private func makeConstraint() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        periodLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(150)
            $0.leading.equalTo(titleLabel.snp.trailing)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        periodLabel.setViewModel(vm.periodLabelVM)
        titleLabel.setViewModel(vm.titleLabelVM)
    }
}
