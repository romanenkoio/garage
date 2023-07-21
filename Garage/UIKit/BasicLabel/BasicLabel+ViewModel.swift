//
//  BasicLabel+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import Combine

extension BasicLabel {
    class ViewModel: BasicViewModel {
        @Published var textValue: TextValue = .text(.empty)
        @Published var isHidden: Bool?
        
        init(_ text: TextValue = .text(.empty)) {
            self.textValue = text
        }
    }
}

extension BasicLabel.ViewModel {
    static let required =  BasicLabel.ViewModel(.text( "*обязательное поле".localized))
}
