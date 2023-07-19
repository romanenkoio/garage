//
//  DateHeaderView.swift
//  Garage
//
//  Created by Illia Romanenko on 18.07.23.
//

import UIKit
import Combine

class DateHeaderView: BasicView {

    private lazy var dateView: BasicView = {
        let view = BasicView()
        view.cornerRadius = 12
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var dateLabel: BasicLabel = {
        let label = BasicLabel(font: .custom(size: 12, weight: .bold))
        label.textColor = AppColors.subtitle
        label.textInsets = .init(vertical: 8, horizontal: 32)
        return label
    }()

    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(dateView)
        dateView.addSubview(dateLabel)
    }
    
    private func makeConstraint() {
        dateView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(UIEdgeInsets(vertical: 10))
            make.center.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.cancellables.removeAll()
        
        self.dateLabel.setViewModel(vm.labelVM)
    }
}
