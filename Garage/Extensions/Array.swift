//
//  Array.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import Foundation

extension Array {
    static var empty: [Element] { [] }
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
