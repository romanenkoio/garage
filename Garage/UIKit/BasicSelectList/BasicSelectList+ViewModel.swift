//
//  BasicSelectList+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import UIKit

extension SuggestionInput {
    final class GenericViewModel<T: Equatable>: BasicInputView.ViewModel {
        typealias Item = T
        
        @Published var items: [Item]
        @Published private(set) var selectedItem: Item?
        private(set) var titles = [String]()
        private(set) var icons = [UIImage]()
                
        init(
            _ list: [Item],
            selected: Item? = nil,
            items: ([Item]) -> [(title: String, image: UIImage?)],
            errorVM: ErrorView.ViewModel,
            inputVM: BasicTextField.ViewModel,
            isRequired: Bool = false
        ) {
            self.items = list
            
            super.init(
                errorVM: errorVM,
                inputVM: inputVM,
                descriptionVM: .init(.text("Документ".localized)),
                isRequired: isRequired
            )

            rules = [.noneEmpty]
            self.titles = items(list).map({ $0.title })
            self.icons = items(list).compactMap({ $0.image })
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
