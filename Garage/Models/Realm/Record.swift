//
//  Record.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import Foundation

final class Record: Object, Codable {
    @Persisted var id: String
    @Persisted var carID: Int
    @Persisted var serviceID: Int?
    @Persisted var cost: Double?
    @Persisted var mileage: Double
    @Persisted var date: Date
    @Persisted var comment: Date?
}
