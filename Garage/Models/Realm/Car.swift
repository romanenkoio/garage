//
//  Car.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import UIKit

final class Car: Object {
    @Persisted var id: String
    @Persisted var brand: String
    @Persisted var model: String
    @Persisted var generation: String?
    @Persisted var year: Int?
    @Persisted var win: String?
    @Persisted var mileage: Int
    
    convenience init(
        brand: String,
        model: String,
        generation: String? = nil,
        year: Int? = nil,
        win: String? = nil,
        mileage: Int
    ) {
        self.init()
        self.id = UUID().uuidString
        self.brand = brand
        self.model = model
        self.generation = generation
        self.year = year
        self.win = win
        self.mileage = mileage
    }
}

