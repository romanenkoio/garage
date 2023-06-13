//
//  AlignedButton.swift
//  Garage
//
//  Created by Illia Romanenko on 13.06.23.
//

import Foundation
import UIKit

final class AlignedButton: BasicView {
    let basicButton = BasicButton()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }

    private func makeLayout() {
        self.addSubview(basicButton)
    }

    private func makeConstraint() {
        basicButton.snp.makeConstraints { make in
            make.width.equalTo(242)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
   
    func setViewModel(_ vm: ViewModel) {
        self.basicButton.setViewModel(vm.buttonVM)
    }
}
