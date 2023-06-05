//
//  Record.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import Foundation

final class Record: Object {
    @Persisted var id: Int
    @Persisted var carID: Int
    @Persisted var serviceID: Int?
    @Persisted var cost: Double?
    @Persisted var mileage: Double
    @Persisted var date: Date
}
