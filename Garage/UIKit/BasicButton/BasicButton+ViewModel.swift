//
//  BasicButton+ViewModel.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 18.05.23.
//

import Foundation
import UIKit

extension BasicButton {
    class ViewModel: BasicViewModel {
        @Published var title: String?
        @Published var isEnabled: Bool
        @Published var action: Action?
        @Published var style: ButtonStyle

        init(
            title: String? = nil,
            isEnabled: Bool = true,
            style: ButtonStyle = .primary,
            action: Action? = nil
        ) {
            self.title = title
            self.isEnabled = isEnabled
            self.action = action
            self.style = style
        }
    }

 
}
