//
//  SeparatorView.swift
//  Garage
//
//  Created by Illia Romanenko on 16.06.23.
//

import Foundation

class SeparatorView: BasicView {
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.cornerRadius = 0
        self.backgroundColor = AppColors.fieldBg
    }
    
    private func makeConstraint() {
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}
