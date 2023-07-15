//
//  BasicSwitch+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 3.06.23.
//

import Combine
import Foundation
import UIKit

extension BasicSwitch {
    class ViewModel: BasicViewModel, HasChangable {
        typealias Value = Bool
        var hasChange: Bool = false
        var hasChangeSubject: CurrentValueSubject<Bool, Never> = .init(false)
        var checkedValue: Bool?
        
        @Published var isOn: Bool = false
        
        init(state: Bool = false) {
            isOn = state
        }
        
        func setState(isOn: Bool) {
            self.isOn = isOn
            checkedValue = isOn
        }

        func changeState(isOn: Bool) {
            self.isOn = isOn
            checkedValue = isOn
        }
        
    }
}

