//
//  BasicLabel+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import Combine

extension BasicLabel {
    class ViewModel: BasicViewModel {
        @Published var text: String? = .empty
        @Published var isHidden: Bool?
        
        init(text: String? = .empty) {
            self.text = text
        }
    }
}
