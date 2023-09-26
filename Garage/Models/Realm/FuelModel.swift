//
//  FuelModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 26.09.23.
//

import Foundation
import RealmSwift
import UIKit

protocol Recordable: Object, Codable {
    var id: String { get set }
    var short: String { get set }
    var carID: String { get set }
    var cost: Int? { get set }
    var date: Date { get set }
}

final class FuelRecord: Object, Recordable {
    @Persisted var id: String
    @Persisted var short: String
    @Persisted var carID: String
    @Persisted var cost: Int?
    @Persisted var date: Date
    @Persisted var quantity: Int?
    
    convenience init(
        short: String,
        carID: String,
        cost: Int? = nil,
        date: Date,
        quantity: Int? = nil
    ) {
        self.init()
        self.id = UUID().uuidString
        self.short = short
        self.carID = carID
        self.cost = cost
        self.date = date
        self.quantity = quantity
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
        case cost
        case date
    }
    
    func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(id, forKey: .id)
          try container.encode(short, forKey: .short)
          try container.encode(carID, forKey: .carID)
          try container.encode(cost, forKey: .cost)
          try container.encode(date, forKey: .date)
      }
}
