//
//  TestController+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import Foundation

extension TestController {
    class ViewModel: BasicViewModel {
        let inputVM = BasicSelectList<TestModel>.GenericViewModel<TestModel>(
            title: "Zalupa",
            [TestModel.init(name: "101"),TestModel.init(name: "101"),TestModel.init(name: "101"),TestModel.init(name: "101"),TestModel.init(name: "101"),TestModel.init(name: "101"),TestModel.init(name: "101"),TestModel.init(name: "101")],
            titles: { items in
                items.map({$0.name})
            },
            errorVM: ErrorView.ViewModel(error: "TestError"),
            inputVM: BasicTextField.ViewModel(placeholder: "Yai4ki")
        )
        
        override init() {
            super.init()
            inputVM.rules = [.noneEmpty]
        }
    }
}

