//
//  Service.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import CoreLocation

final class Service: Object {
    @Persisted var id: Int
    @Persisted var phone: Int
    @Persisted var adress: Int
    @Persisted var specialisation: Int
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
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
