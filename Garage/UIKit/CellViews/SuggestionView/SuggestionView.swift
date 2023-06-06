//
//  SuggestionView.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

class SuggestionView: BasicView {
    
    lazy var label: TappableLabel = {
        let label = TappableLabel(aligment: .center)
        label.textInsets = .init(horizontal: 10)
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraints()
    }
    
    private func makeLayout() {
        self.addSubview(label)
        self.backgroundColor = .textGray
        self.cornerRadius = 12
    }
    
    private func makeConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        label.setViewModel(vm.labelVM)
    }
}
