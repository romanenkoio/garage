//
//  Service.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import CoreLocation
import UIKit

final class Service: Object, Codable {
    @Persisted var id: String
    @Persisted var phone: String
    @Persisted var adress: String
    @Persisted var name: String
    @Persisted var specialisation: String
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    @Persisted var comment: String?
    
    override static func primaryKey() -> String? {
        return "id"
     }
    
    convenience init(
        phone: String,
        adress: String,
        name: String,
        specialisation: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        comment: String?
    ) {
        self.init()
        self.id = UUID().uuidString
        self.phone = phone
        self.adress = adress
        self.name = name
        self.specialisation = specialisation
        self.latitude = latitude
        self.longitude = longitude
        self.comment = comment
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case phone
        case adress
        case name
        case specialisation
        case latitude
        case longitude
        case comment
    }
    
    func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(id, forKey: .id)
          try container.encode(phone, forKey: .phone)
          try container.encode(adress, forKey: .adress)
          try container.encode(name, forKey: .name)
          try container.encode(specialisation, forKey: .specialisation)
          try container.encode(latitude, forKey: .latitude)
          try container.encode(longitude, forKey: .longitude)
          try container.encode(comment, forKey: .comment)
      }
    
}

extension Service {
    var coordinate: CLLocationCoordinate2D? {
        get {
            guard let latitude,
                  let longitude
            else { return nil }
            
            let coordinate = CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
            return coordinate
        }
        set {
            self.latitude = newValue?.latitude
            self.longitude = newValue?.longitude
        }
    }
}
