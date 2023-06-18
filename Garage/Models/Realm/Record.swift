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
    @Persisted var carID: String
    @Persisted var serviceID: String?
    @Persisted var cost: Double?
    @Persisted var mileage: Double
    @Persisted var date: Date
    @Persisted var comment: String?
    
    convenience init(
        carID: String,
        serviceID: String? = nil,
        cost: Double? = nil,
        mileage: Double,
        date: Date,
        comment: String? = nil
    ) {
        self.init()
        self.id = UUID().uuidString
        self.carID = carID
        self.serviceID = serviceID
        self.cost = cost
        self.mileage = mileage
        self.date = date
        self.comment = comment
    }
}

extension Record {
    static let testRecord = Record(carID: "1", mileage: 300000, date: Date())
}
