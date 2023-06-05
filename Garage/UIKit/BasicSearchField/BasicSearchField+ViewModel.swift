//
//  BasicSearchField+ViewModel;.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 22.05.23.
//

import Foundation
import Combine

extension BasicSearchField {
    final class ViewModel: BasicViewModel {
        @Published var text: String
        @Published var placeholder: String?
        @Published var isEnabled: Bool
        private(set) var сloseSearchSubject = PassthroughSubject<Void, Never>()
        
        init(
            text: String = .empty,
            placeholder: String? = nil,
            isEnabled: Bool = true
        ) {
            self.text = text
            self.placeholder = placeholder
            self.isEnabled = isEnabled
        }
    }
}
