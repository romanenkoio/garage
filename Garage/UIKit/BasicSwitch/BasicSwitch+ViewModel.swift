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
        
        var stateSubject: PassthroughSubject<Bool, Never> = .init()
        var isOn: Bool = false
        
        init(state: Bool = false) {
            isOn = state
            stateSubject.send(state)
        }
        
        func changeState(isOn: Bool) {
            self.isOn = isOn
            stateSubject.send(isOn)
        }
        
        func setState(isOn: Bool) {
            self.isOn = isOn
            stateSubject.send(isOn)
            checkedValue = isOn
        }
    }
}

