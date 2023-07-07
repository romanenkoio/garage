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
    @Persisted var short: String
    @Persisted var carID: String
    @Persisted var serviceID: String?
    @Persisted var cost: Int?
    @Persisted var mileage: Int
    @Persisted var date: Date
    @Persisted var comment: String?
    
    convenience init(
        short: String,
        carID: String,
        serviceID: String? = nil,
        cost: Int? = nil,
        mileage: Int,
        date: Date,
        comment: String? = nil
    ) {
        self.init()
        self.id = UUID().uuidString
        self.short = short
        self.carID = carID
        self.serviceID = serviceID
        self.cost = cost
        self.mileage = mileage
        self.date = date
        self.comment = comment
    }
}

extension Record {
    static let testRecord = Record(short: "Test", carID: "1", mileage: 300000, date: Date())
}
