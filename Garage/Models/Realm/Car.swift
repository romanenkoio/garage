//
//  Car.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift

final class Car: Object {
    @Persisted var id: Int
    @Persisted var brand: String
    @Persisted var model: String
    @Persisted var generation: String?
    @Persisted var year: Int?
    @Persisted var win: String?
    @Persisted var mileage: Double
}

