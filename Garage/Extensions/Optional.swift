//
//  Optional.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import Foundation

extension Optional where Wrapped == Int {
    var wrapped: Int {
        return self ?? 0
    }
    
    var wrappedString: String {
        return self?.toString() ?? .empty
    }
}
