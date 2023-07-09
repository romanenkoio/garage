//
//  Service.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import CoreLocation
import UIKit

final class Service: Object, Encodable {
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
