//
//  TestModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import Foundation

class TestModel: Equatable {
    static func == (lhs: TestModel, rhs: TestModel) -> Bool {
        return lhs === rhs ? true : false
    }
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
