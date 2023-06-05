//
//  Compine+Published.swift
//  BSB-Mobile
//
//  Created by User on 21.02.23.
//

import Foundation
import Combine

extension Published.Publisher {
    var didSet: AnyPublisher<Value, Never> {
        self.receive(on: RunLoop.main).eraseToAnyPublisher()
    }
}
