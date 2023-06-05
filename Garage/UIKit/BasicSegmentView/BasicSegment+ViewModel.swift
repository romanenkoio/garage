//
//  BasicSegment+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 22.05.23.
//

import UIKit
import Combine

extension BasicSegmentView {
    final class GenericViewModel<T: Equatable>: BasicViewModel {
        typealias Item = T

        @Published private(set) var items: [Item]
        @Published var selectedItem: Item
        var selectedIndex: Int
//        костыль, решить вопрос с анимацией
        var isFisrstLaunch = true
        
        private(set) var titles = [String]()
        
        init(_ list: [Item], selected: Item, titles: ([Item]) -> [String]) {
            self.selectedItem = selected
            self.items = list
            self.titles = titles(list)
            self.selectedIndex = list.enumerated().first(where: { $0.element == selected })?.offset ?? .zero
            super.init()
            checkEmpty()
        }
        
        func setSelected(_ item: Item) {
            self.selectedItem = item
            self.selectedIndex = items.enumerated().first(where: { $0.element == item })?.offset ?? .zero
        }
        
        private func checkEmpty() {
            guard !items.isEmpty else {
                fatalError("You set empty list. That's illegal!")
            }
        }
    }
}
