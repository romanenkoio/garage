//
//  RangeDatePicker.swift
//  Logogo
//
//  Created by Illia Romanenko on 2.06.23.
//

import UIKit

class RangeDatePicker: BasicView {
    private(set) var viewModel: ViewModel?

    private lazy var stack: BasicStackView = {
        let stak = BasicStackView()
        stak.axis = .horizontal
        stak.spacing = 20
        stak.distribution = .fillEqually
        return stak
    }()
    
    private lazy var startDateInput: BasicDatePicker = {
        let picker = BasicDatePicker()
        return picker
    }()
    
    private lazy var finishDateInput: BasicDatePicker = {
        let picker = BasicDatePicker()
        return picker
    }()
    
    override init() {
        super.init()
        makeLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(stack)
        stack.addArrangedSubviews([startDateInput, finishDateInput])
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: RangeDatePicker.ViewModel) {
        startDateInput.setViewModel(vm.startDateVM)
        finishDateInput.setViewModel(vm.finishDateVM)
    }
}
