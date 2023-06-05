//
//  InfoView+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import Combine
import UIKit

extension InfoView {
    final class ViewModel {
        @Published var title: String
        @Published var subviews = [UIView]()
        var emptyText: String = "Нет данных"
        
        init(
            title: String,
            emptyText: String
        ) {
            self.title = title
            self.emptyText = emptyText
        }
    }
}
