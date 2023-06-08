//
//  Collection.swift
//  Garage
//
//  Created by Illia Romanenko on 8.06.23.
//

import Foundation

extension Collection where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
