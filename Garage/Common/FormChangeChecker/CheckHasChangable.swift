//
//  ChangeListable.swift
//  Garage
//
//  Created by Illia Romanenko on 18.06.23.
//

import Combine

protocol HasChangable: AnyObject {
    associatedtype Value: Equatable

    var hasChange: Bool { get set}
    var hasChangeSubject: CurrentValueSubject<Bool, Never> { get set }
    
    var checkedValue: Value? { get set }
    
    func checkChanged(_ value: Value)
}

extension HasChangable {
    func checkChanged(_ value: Value) {
        guard let checkedValue = self.checkedValue else { return }
        self.hasChange = checkedValue != value
        self.hasChangeSubject.send(checkedValue != value)
    }
}
