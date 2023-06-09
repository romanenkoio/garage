//
//  BasicSelectList+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import Foundation

extension BasicSelectList {
    final class GenericViewModel<T: Equatable>: BasicViewModel {
        typealias Item = T
        
        @Published var items: [Item]
        @Published private(set) var selectedItem: Item?
        private(set) var titles = [String]()
        var errorVM: ErrorView.ViewModel
        let inputVM: BasicTextField.ViewModel
                
        init(
            _ list: [Item],
            selected: Item? = nil,
            titles: ([Item]) -> [String],
            errorVM: ErrorView.ViewModel,
            inputVM: BasicTextField.ViewModel
        ) {
            self.errorVM = errorVM
            self.inputVM = inputVM
            self.items = list
            self.titles = titles(list)
            self.selectedItem = selected
            super.init()
            checkEmpty()
        }
        
        var placeholder: String {
            get { inputVM.placeholder.wrapped }
            set { inputVM.placeholder = newValue}
        }

        var text: String {
            get { inputVM.text }
            set { inputVM.text = newValue}
        }
        
        var rules: [ValidationRule] {
            get { return inputVM.rules }
            set { inputVM.rules = newValue}
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
