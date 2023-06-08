//
//  SuggestionView.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation
import SwiftUI

class SuggestionView: BasicView {
    
    lazy var label: TappableLabel = {
        let label = TappableLabel(aligment: .center)
        label.textInsets = .init(vertical: 10, horizontal: 10)
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraints()
    }
    
    private func makeLayout() {
        self.addSubview(label)
        self.backgroundColor = .secondaryGray
        self.cornerRadius = 12
    }
    
    private func makeConstraints() {
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        label.setViewModel(vm.labelVM)
    }
}
