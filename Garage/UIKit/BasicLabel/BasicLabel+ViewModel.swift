//
//  BasicLabel+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import Combine
import UIKit

extension BasicLabel {
    class ViewModel: BasicViewModel {
        @Published var textValue: TextValue = .text(.empty)
        @Published var isHidden: Bool?
        @Published var textColor: UIColor?
        
        init(_ text: TextValue = .text(.empty)) {
            self.textValue = text
        }
    }
}

extension BasicLabel.ViewModel {
    static let required =  BasicLabel.ViewModel(.text( "*обязательное поле"))
}
