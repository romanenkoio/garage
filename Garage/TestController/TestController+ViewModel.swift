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
            [TestModel.init(name: "101"),TestModel.init(name: "102"),TestModel.init(name: "103"),TestModel.init(name: "104"),TestModel.init(name: "105"),TestModel.init(name: "106"),TestModel.init(name: "107"),TestModel.init(name: "108")],
            titles: { items in
                items.map({$0.name})
            },
            errorVM: .init(error: "Test error"),
            inputVM: .init(placeholder: "Test placeholder")
        )
        
        let buttonVM = BasicButton.ViewModel()
        
        override init() {
            super.init()
            
            inputVM.placeholder = "Test placeholder"
            inputVM.rules = [.noneEmpty]
            buttonVM.style = .primary
            buttonVM.title = "Test button"
            buttonVM.action = .touchUpInside {
                print(self.inputVM.text)
            }
            
        }
    }
}

