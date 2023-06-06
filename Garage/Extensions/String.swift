//
//  String.swift
//  Logogo
//
//  Created by Illia Romanenko on 13.05.23.
//

import Foundation

extension Optional where Wrapped == String {
    var wrapped: String {
        return self ?? .empty
    }
}

extension String {
    static let empty = ""
    
    func toInt() -> Int? {
        return Int(String(self.compactMap({ $0.isWhitespace ? nil : $0 })))
    }
}
