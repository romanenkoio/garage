//
//  Record.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import Foundation
import UIKit

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
    
    @MainActor var images: [Data] {
        return RealmManager<Photo>().read()
            .filter({ $0.recordId == self.id })
            .map({ $0.image })
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case short
        case carID
        case serviceID
        case cost
        case mileage
        case date
        case comment
    }
    
    func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(id, forKey: .id)
          try container.encode(short, forKey: .short)
          try container.encode(carID, forKey: .carID)
          try container.encode(serviceID, forKey: .serviceID)
          try container.encode(cost, forKey: .cost)
          try container.encode(mileage, forKey: .mileage)
          try container.encode(date, forKey: .date)
          try container.encode(comment, forKey: .comment)
      }
}

extension Record {
    static let testRecord = Record(short: "Test", carID: "1", mileage: 300000, date: Date())
}
