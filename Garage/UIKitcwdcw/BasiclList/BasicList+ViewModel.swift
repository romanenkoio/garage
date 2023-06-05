//
//  BasicList+ViewModel.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 29.05.23.
//

import Foundation

extension BasicList {
    class GenericViewModel<T: Equatable>: BasicViewModel {
        typealias Item = T
        
        @Published var title: String
        @Published private(set) var items: [Item]
        @Published private(set) var selectedItem: Item?
        private(set) var placeholder: String
        private(set) var titles = [String]()
        
        init(
            title: String,
            _ list: [Item],
            placeholder: String,
            selected: Item? = nil,
            titles: ([Item]) -> [String]
        ) {
            self.title = title
            self.items = list
            self.titles = titles(list)
            self.selectedItem = selected
            self.placeholder = placeholder
            super.init()
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
                    self.title = titles[index]
                }
            }
        }
    }
}
