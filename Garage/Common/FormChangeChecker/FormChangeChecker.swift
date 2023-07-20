//
//  FormChangeChecker.swift
//  Garage
//
//  Created by Illia Romanenko on 18.06.23.
//

import Foundation
import Combine

class FormChangeChecker {
    var cancellables: Set<AnyCancellable> = .init()
    var formHasChange: PassthroughSubject<Bool, Never> = .init()
    var hasChange: Bool = false
    
    var checkedData: [any HasChangable] = []
    
    func setForm(_ data: [any HasChangable]) {
        self.checkedData = data
        self.sinkAll()
    }
    
    private func sinkAll() {
        cancellables.removeAll()
        
        checkedData.forEach { input in
            input.hasChangeSubject
                .sink { [weak self] _ in
                    self?.checkAll()
                }
                .store(in: &cancellables)
        }
    }
    
    private func checkAll() {
        let result = checkedData.contains(where: { $0.hasChange })
        formHasChange.send(result)
        hasChange = result
    }
}
