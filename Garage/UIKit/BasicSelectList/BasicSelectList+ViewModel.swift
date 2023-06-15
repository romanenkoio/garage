//
//  BasicSelectList+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import Foundation

extension SuggestionInput {
    final class GenericViewModel<T: Equatable>: BasicInputView.ViewModel {
        typealias Item = T
        
        @Published var items: [Item]
        @Published private(set) var selectedItem: Item?
        private(set) var titles = [String]()
                
        init(
            _ list: [Item],
            selected: Item? = nil,
            titles: ([Item]) -> [String],
            errorVM: ErrorView.ViewModel,
            inputVM: BasicTextField.ViewModel,
            isRequired: Bool = false
        ) {
            self.items = list
            
            super.init(
                errorVM: errorVM,
                inputVM: inputVM,
                descriptionVM: .init(text: "Документ"),
                isRequired: isRequired
            )

            rules = [.noneEmpty]
            self.titles = titles(list)
            self.selectedItem = selected
            checkEmpty()
        }
        
        func resetItems(
            _ list: [Item],
            titles: ([Item]) -> [String]
        ) {
            self.items = list
            self.titles = titles(list)
            checkEmpty()
        }
        
        private func checkEmpty() {
            guard !items.isEmpty else {
                fatalError("You set empty list. That's illegal!")
            }
        }
        
        func setSelected(_ item: Item) {
            self.selectedItem = item
            self.items.enumerated().forEach { index, value in
                if item == value {
                    self.inputVM.text = titles[index]
                }
            }
        }
    }
}
