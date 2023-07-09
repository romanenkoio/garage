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
            .filter({ $0.carID == self.id})
            .sorted(by: { $0.date < $1.date })
    }
    
    var records: [Record] {
        RealmManager()
            .read()
            .filter({ $0.carID == self.id})
            .sorted(by: { $0.date < $1.date })
    }
    
    var images: [UIImage] {
        let datas = RealmManager<Photo>().read().filter({ $0.carId == self.id })
        return datas.compactMap({ UIImage(data: $0.image )})
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

