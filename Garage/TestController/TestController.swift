//
//  TestController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import UIKit

class TestController: BasicViewController {
    lazy var basicInputView = BasicSelectList<TestModel>()
    
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
    }
    
    override func layoutElements() {
        contentView.addSubview(basicInputView)
    }
    
    override func binding() {
        basicInputView.setViewModel(vm.inputVM)
    }
}
