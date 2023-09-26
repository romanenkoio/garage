//
//  Car.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import UIKit

final class Car: Object, Codable {
    @Persisted var id: String
    @Persisted var brand: String
    @Persisted var model: String
    @Persisted var generation: String?
    @Persisted var year: Int?
    @Persisted var win: String?
    @Persisted var mileage: Int
    @Persisted var imageData: Data?
    
    var reminders: [Reminder] {
        RealmManager()
            .read()
            .filter({ $0.carID == self.id && !$0.isDone })
            .sorted(by: { $0.date < $1.date })
    }
    
    var records: [Record] {
        RealmManager()
            .read()
            .filter({ $0.carID == self.id})
            .sorted(by: { $0.date > $1.date })
    }
    
    var fuelRecords: [FuelRecord] {
        RealmManager()
            .read()
            .filter({ $0.carID == self.id})
            .sorted(by: { $0.date > $1.date })
    }
    
    var allRecords: [Recordable] {
        let allRecords = records + fuelRecords as! [Recordable]
        return allRecords.sorted(by: {$0.date > $1.date})
    }
    
    var images: [Data] {
        let datas = RealmManager<Photo>().read().filter({ $0.carId == self.id })
        return datas.compactMap({ $0.image })
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case brand
        case model
        case generation
        case year
        case win
        case mileage
        case imageData
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(brand, forKey: .brand)
        try container.encode(model, forKey: .model)
        try container.encode(generation, forKey: .generation)
        try container.encode(year, forKey: .year)
        try container.encode(win, forKey: .win)
        try container.encode(mileage, forKey: .mileage)
        try container.encode(imageData, forKey: .imageData)
    }
    
    convenience init(
        brand: String,
        model: String,
        generation: String? = nil,
        year: Int? = nil,
        win: String? = nil,
        mileage: Int,
        logo: Data?
    ) {
        self.init()
        self.id = UUID().uuidString
        self.brand = brand
        self.model = model
        self.generation = generation
        self.year = year
        self.win = win
        self.mileage = mileage
        self.imageData = logo
    }
}

