//
//  TestController+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import Foundation

extension TestController {
    class ViewModel: BasicViewModel {
        let inputVM = SuggestionInput<TestModel>.GenericViewModel<TestModel>(
            [TestModel.init(name: "101"),TestModel.init(name: "102"),TestModel.init(name: "103"),TestModel.init(name: "104"),TestModel.init(name: "105"),TestModel.init(name: "106"),TestModel.init(name: "107"),TestModel.init(name: "108")],
            items: { items in
                items.map({ ($0.name, nil) })
            },
            errorVM: .init(error: "Test error"),
            inputVM: .init(placeholder: "Test placeholder")
        )
        
        let buttonVM = BasicButton.ViewModel()
        var pickerVM = BasicImageListView.ViewModel()
        
        let barChart = BasicBarChart.GenericViewModel<Record>()

        
        
        override init() {
            barChart.setItems(
                RealmManager<Record>().read()) { items in
                    return items.map({($0.id, $0.date.components.month ?? 0, $0.cost ?? 0)})
                }
            
            super.init()
            inputVM.placeholder = "Test placeholder"
            inputVM.rules = [.noneEmpty]
            buttonVM.style = .primary
            buttonVM.title = "Test button"
            buttonVM.action = .touchUpInside {
                print(self.inputVM.text)
            }
            
            pickerVM.description = "Описание"
        }
    }
}

