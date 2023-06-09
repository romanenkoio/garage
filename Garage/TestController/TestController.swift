//
//  TestController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import UIKit

class TestController: BasicViewController {
    lazy var basicInputView = BasicSelectList<TestModel>()
    lazy var button = BasicButton()
    let vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableScrollView()
    }
    
    override func makeConstraints() {
        basicInputView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(basicInputView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func layoutElements() {
        contentView.addSubview(basicInputView)
        contentView.addSubview(button)
    }
    
    override func binding() {
        basicInputView.setViewModel(vm.inputVM)
        button.setViewModel(vm.buttonVM)
    }
}
