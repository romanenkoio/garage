//
//  BasicList+ViewModel.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 29.05.23.
//

import Foundation
import Combine

extension BasicList {
    class GenericViewModel<T: Equatable>: BasicViewModel, HasChangable, Validatable {
        typealias Item = T
        
        var hasChange: Bool = false
        var hasChangeSubject: CurrentValueSubject<Bool, Never> = .init(false)
        var checkedValue: String?
        
        var rules: [ValidationRule] = .empty
        var isValid: Bool = true
        var isValidSubject: PassthroughSubject<Bool, Never> = .init()
        let descriptionLabelVM = BasicLabel.ViewModel(.text("Выбор сервиса"))
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
        }
        
        func resetItems(
            _ list: [Item],
            titles: ([Item]) -> [String]
        ) {
            self.items = list
            self.titles = titles(list)
        }
 
//         use only for set start value
        func initSelected(_ item: Item?) {
            if item == nil {
                self.checkedValue = .empty
            }
            self.selectedItem = item
            self.items.enumerated().forEach { index, value in
                let isEqual = item == value
                if isEqual {
                    self.checkedValue = titles[index]
                    self.validate()
                    self.title = titles[index]
                }
            }
            self.validate()
        }
        
        func setSelected(_ item: Item) {
            self.selectedItem = item
            self.items.enumerated().forEach { index, value in
                let isEqual = item == value
                if isEqual {
                    self.title = titles[index]
                    self.checkChanged(titles[index])
                    self.validate()
                }
            }
            self.validate()
        }
        
        @discardableResult
        func validate() -> Bool {
            guard !rules.isEmpty else {
                isValid = true
                isValidSubject.send(true)
                return true
            }

            let result = rules.allSatisfy({ validate(title, with: $0) })
            isValid = result
            isValidSubject.send(result)

            return result
        }
        
        func silentVaidate() {
            guard !rules.isEmpty else {
                isValid = true
                return
            }

            let result = rules.allSatisfy({ validate(title, with: $0) })
            isValid = result
        }
    }
}
