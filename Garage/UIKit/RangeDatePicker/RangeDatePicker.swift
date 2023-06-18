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
        stak.spacing = 7
        stak.distribution = .fillEqually
        return stak
    }()
    
    private lazy var descriptionLabel: BasicLabel = {
        let label = BasicLabel()
        label.textColor = ColorScheme.current.textColor
        label.font = .custom(size: 14, weight: .bold)
        label.textInsets = .init(bottom: 16)
        return label
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
        addSubview(descriptionLabel)
        addSubview(stack)
        stack.addArrangedSubviews([startDateInput, finishDateInput])
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
    }
    
    func setViewModel(_ vm: RangeDatePicker.ViewModel) {
        startDateInput.setViewModel(vm.startDateVM)
        finishDateInput.setViewModel(vm.finishDateVM)
        descriptionLabel.setViewModel(vm.desctiptionVM)
    }
}
