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
    
    func toDouble() -> Double {
        var mutatingString = self.replacingOccurrences(of: "[^-0-9.]", with: "", options: .regularExpression)
            .components(separatedBy: .whitespaces)
            .joined(separator: "")

        if self.contains(",") {
            mutatingString = mutatingString.replacingOccurrences(of: ",", with: ".")
        }

        return Double(mutatingString) ?? .zero
    }
}
